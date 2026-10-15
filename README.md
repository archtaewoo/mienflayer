# mienflayer — Roblox 철도 개발 스타터 키트

원형 선로 위를 직접 운전할 수 있는 열차 데모가 들어 있는 Roblox 개발용 시작 프로젝트입니다.

## 바로 해보기 (Rojo 없이)

1. `mienflayer.rbxlx` 파일을 **Roblox Studio**로 엽니다.
2. ▶ **Play**를 누릅니다.
3. 파란색 선두차 지붕의 **운전석(Seat)**에 앉습니다.
4. `W` = 역행(가속), `S` = 제동, 아무 키도 안 누르면 타행. 화면 아래 버튼도 사용할 수 있습니다.
5. `Space`(점프)로 하차합니다.

## 코드로 개발하기 (Rojo)

```bash
aftman install      # rojo / selene / stylua 설치 (aftman.toml 참고)
rojo serve          # Studio의 Rojo 플러그인에서 Connect
rojo build -o mienflayer.rbxlx   # 플레이스 파일 다시 만들기
```

## 구조

| 경로 | Roblox 위치 | 역할 |
|---|---|---|
| `src/shared/Config.luau` | ReplicatedStorage.Shared | 궤간·속도·차량 크기 등 설정 |
| `src/server/TrackBuilder.luau` | ServerScriptService.Server | 원형 선로(레일·침목) 생성 |
| `src/server/TrainService.luau` | ServerScriptService.Server | 열차 생성, 서버 권한 운전 시뮬레이션 |
| `src/server/Main.server.luau` | ServerScriptService.Server | 진입점 |
| `src/client/TrainUI.client.luau` | StarterPlayerScripts.Client | 속도계 HUD, 키보드/버튼 입력 |

## 수치 근거

- **1 stud = 0.28 m** — Roblox Creator Docs, *Units* (https://create.roblox.com/docs/physics/units)
- **표준궤간 1,435 mm** — 국토교통부 「철도의 건설기준에 관한 규정」 및 UIC 표준궤간. 약 5.1 studs로 환산해 사용합니다.
- 가속도·감속도 값은 게임용 임의값이며 실제 차량 성능 값이 아닙니다.
