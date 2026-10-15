# 로블록스 제작팀 (스킬 2 + 부서 에이전트 5)

## 설치
- `skills/roblox-director/`, `skills/roblox-planner/` 폴더를 `~/.claude/skills/` 안에 복사
- `agents/*.md` 파일 5개를 `~/.claude/agents/` 안에 복사
- (Windows 기준 `C:\Users\<이름>\.claude\`)

## Studio 연결 (한 번만)
1. Roblox Studio → Assistant → … → Manage MCP Servers
2. Enable Studio as MCP server 켜기
3. Quick connect에서 Claude Code 켜기
4. Studio와 Claude Code 재시작 후 초록 표시 확인
5. Claude Code에서 `/mcp` 실행 → Studio 서버 이름 확인 (아래 명령의 `Roblox_Studio` 부분)

## 아이디어 정리 먼저 (기획 담당)
대충 말해도 됨:
`/roblox-planner 공포게임에 병원 나오는데 복도 길고 불 깜빡이고 귀신 쫓아오는 느낌`
→ "아, ~하시려는 거죠? 제가 정리해드릴게요" + 기획서 → 승인하면 제작팀에 넘김
이미 만든 것도 정리 가능: `/roblox-planner Workspace의 PCRoom 폴더 지금 어떻게 돼 있는지 정리해줘`

## 아이디어가 아직 정리 안 됐을 때 (추천 시작점)
사진을 첨부하고 생각나는 대로 말하기:
`/roblox-planner 그 왜 병원인데 복도 길고 불 깜빡이고 뭐가 쫓아오는 느낌?`
→ 기획 비서가 "아 이렇게 하시려는 거죠?" 하고 정리 → 확인 → 바로 만들기 / 자는 동안 만들기 선택

## 모티브 게임이 있을 때
`/roblox-planner 이 게임처럼 만들고 싶어: <게임명 또는 링크>` + 핵심 장면 스크린샷
→ 재미 구조 분석표(가져올 것 / 반드시 바꿀 것) → 테마 확인 → 기획서
(다른 게임 코드·에셋 추출은 하지 않음. 약관 위반·저작권 문제)

## 낮에 같이 작업
Claude Code에 사진/컨셉아트를 첨부하고:
`/roblox-director 공포게임용 버려진 병원 복도 만들어줘. 사진 참고.`

## 자는 동안 무인 작업
자기 전에 할 일:
1. 참고 이미지를 프로젝트 폴더 `refs/<작업명>/`에 넣기
2. Studio에서 플레이스를 열고 **백업 저장** (파일 → 다른 이름으로 저장)
3. 윈도우 전원 설정에서 **절전 모드 "안 함"**
4. 아래 명령 실행 (프로젝트 폴더에서):

```
claude -p "/roblox-director 무인 모드. 작업명: hospital. refs/hospital/ 의 이미지로 공포게임용 병원 복도 만들어줘." --model sonnet --permission-mode acceptEdits --allowedTools "mcp__Roblox_Studio" "Agent" "Read" "Write" "Edit"
```

아침에 `refs/<작업명>/report.md` 확인 → Studio에서 결과 보고 마음에 들면 저장.
사용량 한도로 중간에 멈췄으면 같은 명령을 다시 실행하면 log.md 보고 이어서 진행.

## 조직도
기획 비서(roblox-planner) → 감독(roblox-director) → 아트 · 코딩 (동시) → 레벨 → UI → QA → 감독 보고
문제가 있으면 QA가 해당 부서로 되돌림 (최대 3회)

## 기본 모델
| 부서 | 기본 | 감독이 바꾸는 경우 |
|---|---|---|
| 감독 | 실행 시 `--model` (sonnet 권장) | — |
| 아트 · 코딩 | sonnet | 단순 수정은 haiku, 복잡하거나 2번 실패하면 opus |
| 레벨 · UI · QA | haiku | 컨셉 해석이 필요하면 sonnet |
