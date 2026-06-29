# 현실적인 로드맵

## 현재 상태

첫 소형 패치가 성공했다.

성공한 것:

- `Hacknet Nodes` 소개 설명문 3개 치환
- 게임 재시작 후 한국어 정상 표시 확인
- 고유명사 유지 전략 검증
- 번들 직접 치환 방식 검증
- 백업과 패치 기록 생성

아직 하지 않은 것:

- 자동 패처 작성
- 롤백 스크립트 작성
- 네오둥근모 폰트 적용
- 다른 화면 번역 확장
- UI 폭/줄높이 장기 검증

## 운영 원칙

1. 한 번에 한 화면 또는 한 종류의 문자열만 패치한다.
2. 고유명사, API명, 명령어, enum 값은 번역하지 않는다.
3. 매번 백업을 만든다.
4. 패치 기록을 JSON으로 남긴다.
5. 패치 후 실제 화면을 확인한다.
6. 문제가 없으면 다음 범위로 넘어간다.
7. 실패하면 원인 분석보다 먼저 원복 가능성을 확인한다.

## Phase 1. 패치 자동화

목표: 지금 성공한 수동 절차를 재현 가능한 도구로 만든다.

작업:

- `scripts/apply-patch.ps1` 작성
- `scripts/revert-patch.ps1` 작성
- `patches/*.json` 치환표를 읽는 구조 만들기
- 대상 파일 백업 자동 생성
- 치환 전 매치 개수 확인
- 치환 후 원문/번역문 존재 여부 확인
- 패치 로그 출력

완료 기준:

- Steam 업데이트 후에도 같은 JSON으로 재적용 가능
- 실패 시 파일을 쓰지 않고 중단
- 롤백 스크립트로 이전 백업 복구 가능

우선순위: 최상

## Phase 2. 폰트 단독 실험

목표: 네오둥근모 적용이 전체 UI에 미치는 영향을 확인한다.

현재 폰트:

- `C:\Users\user\bitburner kr\assets\fonts\neodgm.ttf`

작업:

- 폰트 파일을 게임 자산 경로에 복사
- `@font-face` 선언 주입
- 기본 폰트 패밀리에 네오둥근모 추가
- 게임 재시작 후 화면 확인

검증 화면:

- Terminal
- Hacknet Nodes
- Script Editor
- Augmentation 모달
- Active Scripts

확인 항목:

- 한글 글자 깨짐 여부
- 줄높이 이상 여부
- 커서 위치 어긋남 여부
- Monaco editor 입력/선택 문제 여부
- 숫자/영어/한글 혼합 시 가독성

판단:

- 문제가 없으면 기본 적용 후보
- 문제가 있으면 본문 UI에만 제한 적용하거나 폰트 적용 보류

우선순위: 높음

## Phase 3. Augmentation 효과 라벨 소형 패치

목표: 반복 생성되는 스탯/효과 문자열을 안정적으로 번역한다.

대상 후보:

- `Effects:` -> `효과:`
- `hacking skill` -> `해킹 스킬`
- `hacking exp` -> `해킹 경험치`
- `all skills` -> `모든 스킬`
- `combat skills` -> `전투 스킬`
- `combat exp` -> `전투 경험치`

대상 원본:

- 소스맵 기준: `src/Augmentation/Augmentation.ts`

검증 화면:

- Augmentation 목록
- Augmentation 상세/구매 모달
- 여러 종류의 효과가 있는 Augmentation

주의:

- Augmentation 이름은 번역하지 않는다.
- multiplier 키나 enum 문자열은 건드리지 않는다.
- `%`와 숫자 포맷은 유지한다.

우선순위: 높음

## Phase 4. Terminal analyze 라벨 패치

목표: 터미널 분석 출력의 핵심 스탯 라벨을 번역한다.

대상 후보:

- `Required hacking skill for hack() and backdoor:`
- `Server security level:`
- `Chance to hack:`
- `Time to hack:`
- `Time to grow:`
- `Time to weaken:`
- `Backdoor:`

대상 원본:

- 소스맵 기준: `src/Terminal/Terminal.ts`

검증:

- `analyze` 명령 실행
- 일반 서버와 Hacknet 계열 서버 비교
- `hack()`, `grow()`, `weaken()`, `backdoor` 표기 유지

우선순위: 중간

## Phase 5. 화면 단위 설명문 확장

목표: 게임 이해에 도움이 되는 설명문을 넓힌다.

후보 순서:

1. Hacknet 관련 나머지 설명/툴팁
2. Faction work 설명
3. Gang 설명/툴팁
4. Active Scripts 통계 라벨
5. Work/Class 결과 문구
6. Tutorial 설명문
7. Documentation 일부

선정 기준:

- 게임 이해에 도움 되는가
- 내부 식별자와 충돌 위험이 낮은가
- 화면에서 바로 검증 가능한가
- 한 번에 되돌리기 쉬운가

우선순위: 중간

## Phase 6. 치환표 체계화

목표: 번역량이 늘어도 관리 가능하게 만든다.

작업:

- `patches/hacknet.json`
- `patches/augmentation_effects.json`
- `patches/terminal_analyze.json`
- `patches/font.json`
- 공통 용어 사전 분리
- 패치별 적용/해제 상태 기록

완료 기준:

- 어떤 화면에 어떤 치환이 들어갔는지 추적 가능
- Steam 업데이트 후 실패한 치환만 식별 가능

우선순위: 중간

## Phase 7. 소스 포크 전환 판단

다음 조건 중 하나라도 만족하면 번들 치환에서 소스 빌드 방식으로 전환을 검토한다.

- 치환 항목이 200개를 넘는다.
- 문장 조립 방식 때문에 자연스러운 한국어가 어렵다.
- 같은 단어가 문맥별로 다르게 번역되어야 한다.
- Steam 업데이트 때 치환 실패가 잦다.
- 언어 선택 옵션이 필요하다.
- 공식 저장소에 기여 가능한 구조를 만들고 싶다.

현재 판단:

- 아직은 번들 치환 방식이 적절하다.
- 최소 3~5개 화면에서 성공 사례를 쌓은 뒤 전환 여부를 판단한다.

## 다음 실행 순서

가장 현실적인 다음 순서:

1. `apply-patch.ps1` / `revert-patch.ps1` 작성
2. 기존 Hacknet 패치를 JSON 기반으로 재적용 가능하게 만들기
3. 폰트 단독 실험
4. Augmentation 효과 라벨 패치
5. Terminal analyze 라벨 패치

## 보류 항목

아직 하지 않는다.

- 전체 UI 일괄 번역
- Faction/Augmentation 이름 번역
- API 함수명 번역
- Documentation 전체 번역
- DOM 후처리 번역
- 소스 전체 포크 빌드

## Phase 1 보강 사항

패처는 다음 네 가지를 필수 요구사항으로 구현한다.

1. `expectedCount`: 예상 매치 수와 다르면 쓰기 전 중단
2. dry-run 기본값: `-Apply` 없이는 파일을 변경하지 않음
3. `patch-state.json`: 적용 결과, 해시, 백업 경로, 시각 기록
4. `allowRemainingSource`: 치환 후 원문 잔존 허용 여부를 항목별로 제어

세부 설계는 `docs/06_patcher_design.md`에 정리했다.

## Phase 1 진행 메모

2026-06-29 기준 패처 초안을 작성했다.

구현된 것:

- `scripts/apply-patch.ps1`
- `scripts/revert-patch.ps1`
- dry-run 기본값
- `-Apply` 명시 적용
- `expectedCount` 검사
- `allowExistingTarget` 기반 이미 적용된 패치 감지
- `allowRemainingSource` 검사
- 백업 생성 설계
- `patch-state.json` 기록 설계
- 단일 patchId 최신 기록 기반 revert 설계
- 기존 `target/replacements` 형식과 신규 `operations` 형식 동시 지원

검증한 것:

- 이미 적용된 Hacknet 패치는 dry-run에서 `already-applied`로 감지된다.
- 이미 적용된 폰트 패치는 dry-run에서 `already-applied`로 감지된다.
- 임시 clean GameRoot에서는 폰트 패치가 `will-copy`, `will-insert`, `will-replace`로 감지된다.

검증 완료:

- `C:\tmp\bbkr-patcher-apply` clean GameRoot에서 Hacknet 패치 `-Apply` 성공
- 같은 clean GameRoot에서 폰트 패치 `-Apply` 성공
- 적용 후 `patch-state.json` 7개 entry 기록 확인
- `revert-patch.ps1 -PatchId font.neodgm.v1 -Apply` 성공
- `revert-patch.ps1 -PatchId hacknet_nodes_intro_small -Apply` 성공
- 최종 상태에서 Hacknet 원문 복구, 한국어 문장 제거, 폰트 파일 제거, force CSS 제거 확인

다음 확인:

- 라이브 게임 파일에는 이미 수동 패치가 적용되어 있으므로 당장은 dry-run 검증만 유지
- 다음 신규 번역 패치부터는 JSON 작성 후 패처로만 적용

## Phase 3 진행 메모

2026-06-29 기준 Augmentation 효과 라벨 소형 패치를 적용했다.

구현된 것:

- `patches/augmentation_effects_small.json`
- `Effects:` / 스킬 / 경험치 라벨 7개 치환
- 패처 기반 dry-run 및 `-Apply` 적용
- 적용 후 source 0회, target 1회 검증

화면 검증 완료:

- `CRTX42-AA`: `효과:`, `해킹 스킬`, `해킹 경험치` 정상 표시
- `Neurotrainer I`: `모든 스킬 경험치` 정상 표시
- Synaptic potentiation 계열: `해킹 경험치`는 표시되지만 `faster hack(), grow(), and weaken()`, `hack() success chance`는 scope 밖이라 영어로 남음
- Synthetic Nerve Enhancement 계열: `dexterity skill`, `agility skill`이 scope 밖이라 영어로 남음

다음 확인:

- Augmentation 효과 라벨 2차 패치로 개별 스킬/경험치/해킹 액션 라벨 추가
- 이후 Terminal analyze 라벨 패치로 이동
