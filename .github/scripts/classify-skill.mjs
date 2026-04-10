#!/usr/bin/env node
/**
 * classify-skill.mjs
 * /tmp/candidates.json의 레포를 Anthropic API로 분류하고
 * 해당 카테고리 파일에 엔트리를 추가한다.
 *
 * Requirements:
 *   - Node.js 20+ (native fetch, execSync — no npm deps)
 *   - ANTHROPIC_API_KEY env var
 *   - gh CLI (GH_TOKEN)
 */

import fs from 'fs';
import path from 'path';
import { spawnSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../..');

// ── 상수 ─────────────────────────────────────────────────────────────────────

const CANDIDATES_FILE = '/tmp/candidates.json';
const SUMMARY_FILE = '/tmp/scout-summary.json';
const KNOWN_REPOS_FILE = path.join(ROOT, 'data/known-repos.json');
const CATEGORIES_DIR = path.join(ROOT, 'categories');
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const MODEL = 'claude-sonnet-4-20250514';

const VALID_CATEGORIES = [
  'ai-prompt', 'backend', 'code-review', 'collections', 'communication',
  'content-media', 'debugging', 'devops', 'documentation', 'frameworks',
  'game-dev', 'git-workflow', 'guides', 'korean-services', 'korean-writing',
  'multi-agent', 'office-docs', 'performance', 'project-init', 'refactoring',
  'research-web', 'security', 'testing', 'utilities', 'web-frontend',
];

const SKILL_TYPE_HEADERS = {
  '🔧': '## 🔧 Skills',
  '🤖': '## 🤖 Agents',
  '⚡': '## ⚡ Commands',
  '🪝': '## 🪝 Hooks',
};

// ── 유틸리티 ──────────────────────────────────────────────────────────────────

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function readJson(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch {
    return null;
  }
}

function writeJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + '\n', 'utf8');
}

function gh(args) {
  const result = spawnSync('gh', args, {
    encoding: 'utf8',
    timeout: 15000,
  });
  return result.status === 0 ? result.stdout.trim() : null;
}

/**
 * owner/repo 형식으로 URL 파싱
 */
function parseOwnerRepo(url) {
  const m = url.match(/github\.com\/([^/]+)\/([^/]+)/);
  if (!m) return null;
  return { owner: m[1], repo: m[2] };
}

/**
 * README 내용을 가져와 최대 3000자로 자름
 */
function fetchReadme(owner, repo) {
  try {
    const b64 = gh(['api', `repos/${owner}/${repo}/readme`, '--jq', '.content']);
    if (!b64) return '';
    const decoded = Buffer.from(b64, 'base64').toString('utf8');
    return decoded.slice(0, 3000);
  } catch {
    return '';
  }
}

/**
 * SKILL.md 파일 목록 조회
 */
function fetchSkillMdList(owner, repo) {
  try {
    const tree = gh(['api', `repos/${owner}/${repo}/git/trees/HEAD?recursive=1`]);
    if (!tree) return [];
    const parsed = JSON.parse(tree);
    return (parsed.tree || [])
      .filter(item => item.path && item.path.endsWith('SKILL.md'))
      .map(item => item.path);
  } catch {
    return [];
  }
}

// ── Anthropic API 호출 ────────────────────────────────────────────────────────

async function classifyWithAI(candidate, readme, skillMdFiles) {
  const prompt = `당신은 GitHub 레포지토리를 분석해서 Claude Code / Gemini CLI / AI 에이전트 스킬 컬렉션 여부를 판별하는 분류기입니다.

## 레포 정보
- URL: ${candidate.url}
- 이름: ${candidate.name}
- 설명: ${candidate.description || '(없음)'}
- Stars: ${candidate.stargazersCount}
- SKILL.md 파일: ${skillMdFiles.length > 0 ? skillMdFiles.join(', ') : '없음'}

## README (최대 3000자)
${readme || '(README 없음)'}

## 분류 지침
1. **한국어 호환성**: 아래 중 하나를 선택
   - "한국어": 주로 한국어로 작성된 스킬/에이전트
   - "영+한": 영어 스킬이지만 한국어 설명/문서 포함
   - "다국어(KO)": 다국어 지원하며 한국어 포함
   - "해당없음": 한국어 관련 없거나 스킬/에이전트 레포가 아님

2. **스킬 타입** (해당없음이면 "none"):
   - "🔧": Skill (SKILL.md 기반 슬래시 커맨드/기능)
   - "🤖": Agent (자율 실행 에이전트)
   - "⚡": Command (단순 커맨드/프롬프트)
   - "🪝": Hook (이벤트 훅)

3. **도구 호환성** (해당없음이면 빈 배열, 복수 선택 가능):
   - "CC": Claude Code
   - "GC": Gemini CLI
   - "CX": Cursor
   - "CP": Copilot
   - "OC": OpenAI Codex
   - "CR": Cline/Roo
   - "WS": Windsurf

4. **카테고리** (아래 26개 중 하나, 해당없으면 "none"):
   ${VALID_CATEGORIES.join(', ')}

5. **한줄 설명**: 한국어로 30자 이내. 스킬/에이전트의 핵심 기능 설명.

## 출력 형식 (JSON만 출력, 설명 없이)
{
  "korean": "한국어|영+한|다국어(KO)|해당없음",
  "type": "🔧|🤖|⚡|🪝|none",
  "tools": ["CC", "GC"],
  "category": "카테고리명|none",
  "description": "한국어 한줄 설명"
}`;

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: MODEL,
      max_tokens: 300,
      messages: [{ role: 'user', content: prompt }],
    }),
  });

  if (!response.ok) {
    const err = await response.text();
    throw new Error(`Anthropic API error ${response.status}: ${err}`);
  }

  const data = await response.json();
  const text = data.content?.[0]?.text || '{}';

  // JSON 추출 (마크다운 코드블록 처리)
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (!jsonMatch) throw new Error(`JSON 파싱 실패: ${text}`);
  return JSON.parse(jsonMatch[0]);
}

// ── 카테고리 파일 수정 ────────────────────────────────────────────────────────

/**
 * 레포 이름을 URL에서 추출 (마지막 경로 세그먼트)
 */
function repoName(url) {
  return url.split('/').pop() || 'unknown';
}

/**
 * 카테고리 파일의 해당 섹션에 테이블 행 추가
 * 섹션이 없으면 파일 끝에 생성
 */
function addEntryToCategory(categoryFile, skillType, entry) {
  let content = fs.readFileSync(categoryFile, 'utf8');
  const sectionHeader = SKILL_TYPE_HEADERS[skillType];

  if (!sectionHeader) {
    console.warn(`  알 수 없는 스킬 타입: ${skillType}`);
    return false;
  }

  const tableHeader = '| 이름 | 도구 | 설명 | 언어 | 레포 |\n|------|------|------|------|------|';
  const newRow = `| ${entry.name} | ${entry.tools} | ${entry.description} | ${entry.language} | [${entry.repoName}](${entry.url}) |`;

  const sectionIdx = content.indexOf(sectionHeader);

  if (sectionIdx === -1) {
    // 섹션 없음: 파일 끝에 추가
    if (!content.endsWith('\n')) content += '\n';
    content += `\n${sectionHeader}\n\n${tableHeader}\n${newRow}\n`;
  } else {
    // 섹션 있음: 해당 섹션의 마지막 테이블 행 뒤에 삽입
    // 섹션 시작 이후에서 다음 ## 헤더 또는 파일 끝까지 범위 결정
    const afterSection = content.slice(sectionIdx + sectionHeader.length);
    const nextSectionMatch = afterSection.match(/\n## /);
    const sectionEnd = nextSectionMatch
      ? sectionIdx + sectionHeader.length + nextSectionMatch.index
      : content.length;

    const sectionContent = content.slice(sectionIdx, sectionEnd);

    // 섹션 내 마지막 테이블 행 찾기 (| 로 시작하는 마지막 줄)
    const tableRows = [...sectionContent.matchAll(/^(\|.+\|)\s*$/gm)];

    if (tableRows.length === 0) {
      // 테이블 없음: 섹션 헤더 바로 뒤에 테이블 헤더 + 행 추가
      const insertAt = sectionIdx + sectionHeader.length;
      const beforeInsert = content.slice(0, insertAt);
      const afterInsert = content.slice(insertAt);
      content = `${beforeInsert}\n\n${tableHeader}\n${newRow}\n${afterInsert}`;
    } else {
      // 마지막 테이블 행 바로 뒤에 삽입
      const lastRow = tableRows[tableRows.length - 1];
      const insertAt = sectionIdx + lastRow.index + lastRow[0].length;
      const beforeInsert = content.slice(0, insertAt);
      const afterInsert = content.slice(insertAt);
      content = `${beforeInsert}\n${newRow}${afterInsert}`;
    }
  }

  fs.writeFileSync(categoryFile, content, 'utf8');
  return true;
}

// ── known-repos.json 업데이트 ─────────────────────────────────────────────────

function updateKnownRepos(url, skills = []) {
  const data = readJson(KNOWN_REPOS_FILE) || { repos: [] };
  const existing = data.repos.find(r => r.url === url);
  const entry = {
    url,
    last_scanned: new Date().toISOString(),
    skills,
  };

  if (existing) {
    Object.assign(existing, entry);
  } else {
    data.repos.push(entry);
  }

  data.last_updated = new Date().toISOString();

  writeJson(KNOWN_REPOS_FILE, data);
}

// ── 메인 ──────────────────────────────────────────────────────────────────────

async function main() {
  if (!ANTHROPIC_API_KEY) {
    console.error('ANTHROPIC_API_KEY 환경변수가 없습니다.');
    process.exit(1);
  }

  if (!fs.existsSync(CANDIDATES_FILE)) {
    console.error(`후보 파일 없음: ${CANDIDATES_FILE}`);
    process.exit(1);
  }

  const candidates = JSON.parse(fs.readFileSync(CANDIDATES_FILE, 'utf8'));
  console.log(`▶ classify-skill.mjs 시작: ${candidates.length}개 후보`);

  const summary = { added: 0, rejected: 0, issues: 0, skills: [] };

  for (const candidate of candidates) {
    console.log(`\n─── ${candidate.url}`);

    const parsed = parseOwnerRepo(candidate.url);
    if (!parsed) {
      console.warn('  URL 파싱 실패, 스킵');
      summary.rejected++;
      updateKnownRepos(candidate.url, []);
      continue;
    }

    const { owner, repo } = parsed;

    // README 및 SKILL.md 목록 수집
    const readme = fetchReadme(owner, repo);
    const skillMdFiles = fetchSkillMdList(owner, repo);
    console.log(`  README: ${readme.length}자, SKILL.md: ${skillMdFiles.length}개`);

    // Anthropic API 분류
    let classification;
    try {
      classification = await classifyWithAI(candidate, readme, skillMdFiles);
      console.log(`  분류: ${JSON.stringify(classification)}`);
    } catch (err) {
      console.error(`  API 오류: ${err.message}`);
      summary.rejected++;
      updateKnownRepos(candidate.url, []);
      await sleep(1000);
      continue;
    }

    const isKorean = ['한국어', '영+한', '다국어(KO)'].includes(classification.korean);
    const hasCategory = classification.category && classification.category !== 'none';
    const hasType = classification.type && classification.type !== 'none';

    if (!isKorean || !hasCategory) {
      console.log(`  → 제외 (한국어: ${classification.korean}, 카테고리: ${classification.category})`);
      summary.rejected++;
      updateKnownRepos(candidate.url, []);
      await sleep(1000);
      continue;
    }

    if (!hasType) {
      // 카테고리는 있지만 타입 불명확 → 이슈 생성
      console.log(`  → 카테고리 있으나 타입 불명확, 이슈 생성`);
      try {
        const title = `🔍 스킬 수동 분류 필요: ${candidate.name}`;
        const body = `## 자동 분류 실패\n\n- **레포**: ${candidate.url}\n- **설명**: ${candidate.description || '없음'}\n- **한국어**: ${classification.korean}\n- **제안 카테고리**: ${classification.category}\n- **타입 판별 실패**\n\n수동으로 확인 후 적절한 카테고리에 추가해주세요.`;
        gh(['issue', 'create', '--title', title, '--body', body, '--label', 'manual-review']);
        summary.issues++;
      } catch (err) {
        console.error(`  이슈 생성 실패: ${err.message}`);
      }
      updateKnownRepos(candidate.url, []);
      await sleep(1000);
      continue;
    }

    // 카테고리 파일에 엔트리 추가
    const categoryFile = path.join(CATEGORIES_DIR, `${classification.category}.md`);

    if (!fs.existsSync(categoryFile)) {
      console.warn(`  카테고리 파일 없음: ${categoryFile}, 이슈 생성`);
      try {
        const title = `🔍 신규 카테고리 필요: ${classification.category}`;
        const body = `## 자동 스킬 추가 실패\n\n- **레포**: ${candidate.url}\n- **제안 카테고리**: \`${classification.category}\`\n\n카테고리 파일이 없어 추가할 수 없었습니다.`;
        gh(['issue', 'create', '--title', title, '--body', body, '--label', 'manual-review']);
        summary.issues++;
      } catch {}
      updateKnownRepos(candidate.url, []);
      await sleep(1000);
      continue;
    }

    const toolsStr = Array.isArray(classification.tools) ? classification.tools.join('/') : (classification.tools || 'CC');

    const entry = {
      name: candidate.name,
      tools: toolsStr,
      description: classification.description || candidate.description || '',
      language: classification.korean,
      repoName: repoName(candidate.url),
      url: candidate.url,
    };

    const added = addEntryToCategory(categoryFile, classification.type, entry);

    if (added) {
      console.log(`  → 추가됨: ${classification.category} / ${classification.type}`);
      summary.added++;
      summary.skills.push({
        name: candidate.name,
        url: candidate.url,
        category: classification.category,
        type: classification.type,
        description: classification.description,
      });
      updateKnownRepos(candidate.url, [{ name: candidate.name, category: classification.category }]);
    } else {
      summary.rejected++;
      updateKnownRepos(candidate.url, []);
    }

    await sleep(1000);
  }

  // 요약 저장
  fs.writeFileSync(SUMMARY_FILE, JSON.stringify(summary, null, 2) + '\n', 'utf8');

  console.log(`\n▶ 완료: 추가 ${summary.added}개, 제외 ${summary.rejected}개, 이슈 ${summary.issues}개`);
  console.log(`  요약 → ${SUMMARY_FILE}`);
}

main().catch(err => {
  console.error('오류:', err);
  process.exit(1);
});
