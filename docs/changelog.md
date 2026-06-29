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
