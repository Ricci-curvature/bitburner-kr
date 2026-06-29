# 변경 기록

## 2026-06-29

- `C:\Users\user\bitburner kr` 작업 루트 정리
- 네오둥근모 폰트 `assets\fonts\neodgm.ttf` 복사
- 조사 상황 문서 작성
- 패치 방향 문서 작성
- 단계별 로드맵 작성
- 번역 정책 초안 작성

## 2026-06-29 - Hacknet Nodes intro small patch

- `resources/app/dist/main.bundle.js` 백업 생성
- `Hacknet Nodes` 화면의 소개 설명문 3개만 한국어로 치환
- 고유명사 `Hacknet`, `Hacknet Node`, `Node` 유지
- 검증: 한국어 3개 문자열 발견, 원문 3개 문자열 미검출
- 패치 기록: `patches/hacknet_nodes_intro_small.json`

## 2026-06-29 - 첫 패치 성공 문서화 및 로드맵 갱신

- `docs/05_first_patch_result.md` 추가
- `docs/03_roadmap.md`를 현실적인 실행 순서로 재작성
- `docs/02_patch_direction.md`에 첫 성공 이후 방향 수정 추가
- 다음 우선순위를 자동 패처, 폰트 단독 실험, Augmentation 효과 라벨로 정리

## 2026-06-29 - Phase 1 패처 설계 보강

- `docs/06_patcher_design.md` 추가
- `expectedCount`, dry-run 기본값, `patch-state.json`, `allowRemainingSource` 요구사항 반영
- 로드맵 Phase 1에 패처 필수 안전장치 추가

## 2026-06-29 - GitHub repo 준비

- `Ricci-curvature/bitburner-kr` 저장소 생성을 목표로 로컬 git 저장소화를 준비했다.
- 게임 번들 백업(`backups/*`)과 폰트 원본(`assets/fonts/*`)은 라이선스/배포 리스크 때문에 git 추적에서 제외했다.
- Phase 1 패처는 dry-run 기본값, expected count, patch-state, 원문 잔존 검사 규칙을 필수 안전장치로 둔다.

## 2026-06-29 - NeoDunggeunmo 폰트 실험

- Bitburner 앱 리소스에 `dist/fonts/neodgm.ttf`를 복사했다.
- `index.html`에 `@font-face`를 추가했다.
- `main.bundle.js`의 기본 font stack 4곳을 `NeoDunggeunmo` 우선으로 치환했다.
- README에 첫 Hacknet 한글 출력 스크린샷을 추가했다.

## 2026-06-29 - NeoDunggeunmo 1차 실패 및 force CSS 실험

- 사용자 스크린샷 기준 1차 font stack 치환은 실제 화면 폰트 변경으로 이어지지 않았다.
- TTF 내부 family 이름은 `NeoDunggeunmo`로 확인했다.
- `index.html`에 `#root` 하위 텍스트와 입력/코드/Monaco 계열에 대한 `!important` font-family 강제 CSS를 추가했다.

## 2026-06-29 - NeoDunggeunmo fallback 순서 조정

- force CSS 적용 결과 게임 전체 영문/숫자/UI까지 네오둥근모로 바뀌는 것을 확인했다.
- 목적을 한글 glyph 보강으로 좁히기 위해 font stack을 `JetBrainsMono, NeoDunggeunmo, "Courier New", monospace` 순서로 변경했다.
- 이제 영문/숫자는 기존 JetBrainsMono, 한글은 NeoDunggeunmo fallback을 기대한다.

## 2026-06-29 - 폰트 변경 스크린샷 추가

- `screenshot/폰트변경.png`를 추가했다.
- README와 폰트 실험 문서에 force CSS 성공 화면을 연결했다.
- 이 스크린샷은 NeoDunggeunmo가 실제 렌더링에 적용되었지만 전체 UI 폰트까지 바뀐 상태를 기록한다.

## 2026-06-29 - README 실험 로그 분리

- README의 실험 상세와 스크린샷을 `docs/08_experiment_log.md`로 분리했다.
- README는 현재 상태, 문서 링크, 다음 후보 중심으로 축약했다.
- 폰트 전략은 전체 UI NeoDunggeunmo 적용을 기본 후보로 다시 정리했다.

## 2026-06-29 - 전체 UI NeoDunggeunmo 전략 확정 후보

- 스크린샷 검토 후 NeoDunggeunmo의 영문/숫자까지 Bitburner 분위기에 잘 맞는다고 판단했다.
- `font_neodgm_experiment.json`의 기본 target을 `NeoDunggeunmo, JetBrainsMono, "Courier New", monospace`로 되돌렸다.
- 실제 게임 파일도 전체 UI NeoDunggeunmo 우선 순서로 다시 맞췄다.
- Monaco 코드 에디터만 예외 처리할지는 추후 긴 스크립트 편집 화면을 보고 판단한다.
