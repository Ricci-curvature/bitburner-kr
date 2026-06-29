# Bitburner KR Patch Lab

Bitburner 스팀판에 대한 한국어 표시 패치를 작은 범위부터 검증하기 위한 작업 루트입니다.

## 목표

- 게임 고유명사, API 이름, 명령어, 내부 식별자는 유지한다.
- 설명문, 툴팁, 효과 설명, 스탯 라벨처럼 플레이어가 읽는 문장 중심으로 한글화한다.
- Steam 업데이트 이후에도 재적용할 수 있도록 직접 수정 내역보다 패처와 치환표를 남긴다.
- 한글 폰트는 네오둥근모를 우선 사용한다.

## 현재 확인된 환경

- Bitburner 설치 경로: `D:\SteamLibrary\steamapps\common\Bitburner`
- 앱 구조: Electron 앱
- 게임 번들: `resources\app\dist\main.bundle.js`
- 원본 소스맵: `resources\app\dist\main.bundle.js.map`
- HTML 엔트리: `resources\app\index.html`
- 폰트 파일: `assets\fonts\neodgm.ttf` 로컬 보관, git 추적 제외

## 현재 상태

- Hacknet Nodes 설명문 3개 한글화 성공
- NeoDunggeunmo 폰트 로드 및 force CSS 적용 성공
- 현재 폰트 전략은 전체 UI NeoDunggeunmo 적용을 기본 후보로 두고, 필요 시 Monaco 코드 에디터만 예외 처리하는 방향
- Phase 1 패처는 dry-run 기본값, `expectedCount`, `allowRemainingSource`, `patch-state.json` 기록을 필수 안전장치로 설계
- Augmentation 효과 라벨 1차/2차 패치 적용 및 화면 검증 완료
- Terminal `analyze` 출력 라벨 패치 적용 및 화면 검증 완료
- Hacknet 요약 박스/구매 버튼 라벨 패치 적용 및 화면 검증 완료
- Hacknet Node 카드 라벨/최대치 버튼 패치 적용 완료

자세한 실험 진행 상황과 스크린샷은 [`docs/08_experiment_log.md`](docs/08_experiment_log.md)를 본다.

## 문서

- `docs/01_research_notes.md`: 조사한 사실과 근거
- `docs/02_patch_direction.md`: 패치 방향과 금지 구역
- `docs/03_roadmap.md`: 단계별 로드맵
- `docs/04_translation_policy.md`: 번역 정책과 용어 기준
- `docs/05_first_patch_result.md`: 첫 Hacknet 설명문 패치 결과
- `docs/06_patcher_design.md`: Phase 1 패처 안전장치 설계
- `docs/07_font_experiment.md`: NeoDunggeunmo 폰트 실험 상세
- `docs/08_experiment_log.md`: 실험 진행 상황과 스크린샷 로그

## 다음 실험 후보

1. Monaco 코드 에디터에서 NeoDunggeunmo 전체 UI 적용의 실사용 확인.
2. Hacknet Node 카드 라벨 화면 검증 스크린샷 기록.
3. Hacknet 관련 나머지 설명/툴팁 확장.
4. Active Scripts 또는 Faction work 라벨 소형 패치.




