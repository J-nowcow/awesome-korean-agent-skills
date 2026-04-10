#!/usr/bin/env node
/**
 * pick-weekly.mjs
 * Selects 3 weekly picks from categories/*.md using the Anthropic API,
 * updates README.md "이 주의 스킬" section and data/weekly-picks-history.json.
 *
 * Requirements:
 *   - Node.js 20+ (native fetch, fs/path built-ins only — no npm deps)
 *   - ANTHROPIC_API_KEY env var
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../..');

// ── helpers ──────────────────────────────────────────────────────────────────

function readFile(rel) {
  return fs.readFileSync(path.join(ROOT, rel), 'utf8');
}

function writeFile(rel, content) {
  fs.writeFileSync(path.join(ROOT, rel), content, 'utf8');
}

function today() {
  return new Date().toISOString().slice(0, 10); // YYYY-MM-DD
}

// ── 1. Extract all skills from categories/*.md ───────────────────────────────

/**
 * Parses a pipe-delimited markdown table row into an array of trimmed cells.
 * Returns null if the row is a separator (---|---).
 */
function parseTableRow(line) {
  if (!/^\|/.test(line)) return null;
  const cells = line.split('|').slice(1, -1).map(c => c.trim());
  if (cells.every(c => /^[-: ]+$/.test(c))) return null; // separator row
  return cells;
}

/**
 * Determines the column layout from the header row.
 * Standard: 이름 | 도구 | 설명 | 언어 | 레포
 * Frameworks: 레포 | Stars | 도구 | 규모 | 언어
 */
function detectLayout(headerCells) {
  const h = headerCells.map(c => c.toLowerCase());
  if (h[0].includes('레포') || h[0].includes('repo')) return 'frameworks';
  return 'standard';
}

/**
 * Extract a repo shortname and full URL from a markdown link cell like:
 *   [repo-name](https://github.com/org/repo/blob/main/...)
 * Returns { repoName, repoUrl, repoId } where repoId is "org/repo".
 */
function parseRepoCell(cell) {
  const m = cell.match(/\[([^\]]+)\]\((https?:\/\/[^)]+)\)/);
  if (!m) return { repoName: cell, repoUrl: '', repoId: '' };
  const repoName = m[1];
  const repoUrl = m[2];
  // Normalise to org/repo
  const ghMatch = repoUrl.match(/github\.com\/([^/]+\/[^/?#\s]+)/);
  const repoId = ghMatch ? ghMatch[1] : repoUrl;
  return { repoName, repoUrl, repoId };
}

function extractSkillsFromFile(filePath) {
  const category = path.basename(filePath, '.md');
  const content = readFile(path.relative(ROOT, filePath));
  const lines = content.split('\n');

  const skills = [];
  let currentType = '';
  let headerCells = null;
  let layout = 'standard';
  let inTable = false;

  for (const line of lines) {
    // Section header → update type emoji
    const sectionMatch = line.match(/^## ([\S]+)\s+(.*)/);
    if (sectionMatch) {
      // e.g. "## 🤖 Agents" or "## 🔧 Skills"
      currentType = sectionMatch[1]; // emoji part
      headerCells = null;
      inTable = false;
      continue;
    }

    // If we haven't found a section header yet, check for top-level table
    // (frameworks.md has a single top-level table with no section header)
    const cells = parseTableRow(line);
    if (!cells) {
      if (line.trim() === '') inTable = false;
      continue;
    }

    if (!headerCells) {
      // This is a header row
      headerCells = cells;
      layout = detectLayout(cells);
      inTable = true;
      continue;
    }

    if (!inTable) continue;

    // Data row
    if (layout === 'standard') {
      // 이름 | 도구 | 설명 | 언어 | 레포
      const [name, tools, description, language, repoCell] = cells;
      if (!name || !repoCell) continue;
      const { repoName, repoUrl, repoId } = parseRepoCell(repoCell);
      skills.push({ name, tools, description, language, repoName, repoUrl, repoId, type: currentType || '🔧', category });
    } else {
      // frameworks layout: 레포 | Stars | 도구 | 규모 | 언어
      const [repoCell, stars, tools, scale, language] = cells;
      if (!repoCell) continue;
      const { repoName, repoUrl, repoId } = parseRepoCell(repoCell);
      const name = repoName;
      const description = scale ? `${scale} — ${language}` : language || '';
      skills.push({ name, tools, description, language: language || '', repoName, repoUrl, repoId, type: '📦', category });
    }
  }

  return skills;
}

function extractAllSkills() {
  const catDir = path.join(ROOT, 'categories');
  const files = fs.readdirSync(catDir)
    .filter(f => f.endsWith('.md'))
    .map(f => path.join(catDir, f));

  const all = [];
  for (const f of files) {
    try {
      all.push(...extractSkillsFromFile(f));
    } catch (err) {
      console.warn(`[warn] Failed to parse ${f}: ${err.message}`);
    }
  }
  return all;
}

// ── 2. Filter out previously picked repos ────────────────────────────────────

function loadHistory() {
  try {
    return JSON.parse(readFile('data/weekly-picks-history.json'));
  } catch {
    return { picks: [] };
  }
}

function saveHistory(history) {
  writeFile('data/weekly-picks-history.json', JSON.stringify(history, null, 2) + '\n');
}

function getPreviousRepos(history) {
  const repos = new Set();
  for (const entry of history.picks) {
    for (const item of entry.items) {
      if (item.repo) repos.add(item.repo);
    }
  }
  return repos;
}

// ── 3. Call Anthropic API ─────────────────────────────────────────────────────

async function callAnthropic(candidates) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) throw new Error('ANTHROPIC_API_KEY is not set');

  const candidateList = candidates
    .map((s, i) => `${i}: name="${s.name}", category="${s.category}", type="${s.type}", tools="${s.tools}", description="${s.description}", repo="${s.repoId}"`)
    .join('\n');

  const prompt = `당신은 한국어 AI 에이전트 스킬 큐레이터입니다.
아래 후보 스킬 목록에서 이번 주 추천 스킬 3개를 선정해 주세요.

선정 기준:
1. 다양한 카테고리에서 고르게 선택 (같은 category 중복 최소화)
2. 한국어 지원이 좋은 것 우선
3. 실용성이 높은 것 우선
4. 다양한 type (🤖 Agent, 🔧 Skill, 📦 Framework 등) 혼합 권장

후보 목록:
${candidateList}

응답 형식: JSON 배열만 반환하세요. 다른 텍스트 없이 JSON만.
[
  {"index": <숫자>, "reason_ko": "<한국어 추천 이유 1~2문장>", "reason_en": "<English reason 1-2 sentences>"},
  {"index": <숫자>, "reason_ko": "...", "reason_en": "..."},
  {"index": <숫자>, "reason_ko": "...", "reason_en": "..."}
]`;

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 1024,
      messages: [{ role: 'user', content: prompt }],
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Anthropic API error ${response.status}: ${body}`);
  }

  const data = await response.json();
  const text = data.content[0].text.trim();

  // Strip markdown code fences if present
  const jsonText = text.replace(/^```(?:json)?\n?/, '').replace(/\n?```$/, '').trim();

  return JSON.parse(jsonText);
}

// ── 4. Update README.md ───────────────────────────────────────────────────────

/**
 * Replaces the 3 data rows in the "이 주의 스킬" table and updates the date.
 * Table structure in README.md:
 *   ## 이 주의 스킬
 *   > ... 최근 업데이트: YYYY-MM-DD
 *   | 스킬 | 도구 | 왜 추천? | 링크 |
 *   |------|:---:|---------|------|
 *   | row1 |
 *   | row2 |
 *   | row3 |
 *   (blank line or ---)
 */
function updateReadme(picks, dateStr) {
  let readme = readFile('README.md');

  // Update date in the blockquote
  readme = readme.replace(
    /(최근 업데이트:\s*)\d{4}-\d{2}-\d{2}/,
    `$1${dateStr}`
  );

  // Build new table rows
  const rows = picks.map(({ skill, reason }) => {
    const { type, name, tools, repoName, repoUrl } = skill;
    return `| ${type} ${name} | ${tools} | ${reason} | [${repoName}](${repoUrl}) |`;
  });

  // Replace data rows: find the table header + separator, then replace the next 3 lines
  // Pattern: header row then separator row then N data rows until blank line or ---
  const tablePattern = /(^\| 스킬 \| 도구 \| 왜 추천\? \| 링크 \|.*\n\|[-:| ]+\|[ ]*\n)([\s\S]*?)(\n---|\n\n)/m;
  readme = readme.replace(tablePattern, (_, headerPart, _dataPart, ending) => {
    return `${headerPart}${rows.join('\n')}${ending}`;
  });

  writeFile('README.md', readme);
}

/**
 * Replaces the 3 data rows in the "Skill of the Week" table in README.en.md and updates the date.
 * Table structure in README.en.md:
 *   ## Skill of the Week
 *   > ... Last updated: YYYY-MM-DD
 *   | Skill | Tools | Why Recommended? | Link |
 *   |------|:---:|---------|------|
 *   | row1 |
 *   | row2 |
 *   | row3 |
 *   (blank line or ---)
 */
function updateReadmeEn(picks, dateStr) {
  let readme = readFile('README.en.md');

  // Update date in the blockquote
  readme = readme.replace(
    /(Last updated:\s*)\d{4}-\d{2}-\d{2}/,
    `$1${dateStr}`
  );

  // Build new table rows with English reasons
  const rows = picks.map(({ skill, reasonEn }) => {
    const { type, name, tools, repoName, repoUrl } = skill;
    return `| ${type} ${name} | ${tools} | ${reasonEn} | [${repoName}](${repoUrl}) |`;
  });

  // Replace data rows
  const tablePattern = /(^\| Skill \| Tools \| Why Recommended\? \| Link \|.*\n\|[-:| ]+\|[ ]*\n)([\s\S]*?)(\n---|\n\n)/m;
  readme = readme.replace(tablePattern, (_, headerPart, _dataPart, ending) => {
    return `${headerPart}${rows.join('\n')}${ending}`;
  });

  writeFile('README.en.md', readme);
}

// ── 5. Update history ─────────────────────────────────────────────────────────

function appendHistory(history, dateStr, picks) {
  const items = picks.map(({ skill }) => ({
    name: skill.name,
    repo: skill.repoId,
    category: skill.category,
    type: skill.type,
    tools: skill.tools,
  }));

  history.picks.push({ date: dateStr, items });
  saveHistory(history);
}

// ── main ──────────────────────────────────────────────────────────────────────

async function main() {
  const dateStr = today();
  console.log(`[pick-weekly] Running for ${dateStr}`);

  // 1. Extract all skills
  let allSkills = extractAllSkills();
  console.log(`[pick-weekly] Extracted ${allSkills.length} skills from categories/`);

  // 2. Load history and filter
  let history = loadHistory();
  let previousRepos = getPreviousRepos(history);
  let candidates = allSkills.filter(s => !previousRepos.has(s.repoId));
  console.log(`[pick-weekly] Candidates after filtering previous picks: ${candidates.length}`);

  // Edge case: pool too small → reset history
  if (candidates.length < 3) {
    console.warn('[pick-weekly] Candidate pool < 3. Resetting history and picking from all skills.');
    history = { picks: [] };
    saveHistory(history);
    candidates = allSkills;
  }

  if (candidates.length === 0) {
    throw new Error('No candidate skills found. Check categories/ directory.');
  }

  // 3. Call Anthropic API
  console.log('[pick-weekly] Calling Anthropic API...');
  const selections = await callAnthropic(candidates);

  if (!Array.isArray(selections) || selections.length < 3) {
    throw new Error(`Unexpected API response: ${JSON.stringify(selections)}`);
  }

  // Map selections back to skill objects
  const picks = selections.slice(0, 3).map(sel => {
    const skill = candidates[sel.index];
    if (!skill) throw new Error(`Invalid index ${sel.index} from API response`);
    return { skill, reason: sel.reason_ko, reasonEn: sel.reason_en };
  });

  console.log('[pick-weekly] Selected picks:');
  for (const { skill, reason } of picks) {
    console.log(`  - ${skill.type} ${skill.name} (${skill.category}) — ${skill.repoId}`);
    console.log(`    ${reason}`);
  }

  // 4. Update README.md
  updateReadme(picks, dateStr);
  console.log('[pick-weekly] README.md updated.');

  // 4b. Update README.en.md
  updateReadmeEn(picks, dateStr);
  console.log('[pick-weekly] README.en.md updated.');

  // 5. Update history
  appendHistory(history, dateStr, picks);
  console.log('[pick-weekly] data/weekly-picks-history.json updated.');

  console.log('[pick-weekly] Done.');
}

main().catch(err => {
  console.error('[pick-weekly] Fatal error:', err);
  process.exit(1);
});
