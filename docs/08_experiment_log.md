# 08. 실험 진행 로그

Bitburner KR 패치의 실제 실험 결과와 스크린샷을 모아 두는 문서다. README에는 현재 상태와 링크만 유지하고, 세부 시행착오와 판단 근거는 이 문서에 기록한다.

## 2026-06-29 - Hacknet Nodes 설명문 한글화

목표:

- 게임 고유명사와 UI 식별자는 유지한다.
- 설명문 3개만 작은 범위로 한글화한다.
- 원문 치환이 실제 게임 화면에 반영되는지 확인한다.

결과:

- `resources/app/dist/main.bundle.js`에서 Hacknet Nodes 소개 문장 3개를 치환했다.
- `Hacknet`, `Hacknet Node`, `Node`, `hack`은 유지했다.
- 게임 재실행 후 화면 반영을 확인했다.

스크린샷:

![첫 출력](../screenshot/%EC%B2%AB%20%EC%B6%9C%EB%A0%A5.png)

관련 문서:

- `docs/05_first_patch_result.md`
- `patches/hacknet_nodes_intro_small.json`

## 2026-06-29 - NeoDunggeunmo 폰트 1차 실험

목표:

- 한글 표시 품질을 위해 NeoDunggeunmo를 앱 리소스로 로드한다.
- 번들 기본 font stack 앞에 NeoDunggeunmo를 추가한다.

결과:

- `dist/fonts/neodgm.ttf` 복사 성공
- `index.html` `@font-face` 삽입 성공
- `main.bundle.js` font stack 4곳 치환 성공
- 하지만 사용자 확인 결과 실제 화면 폰트 변화가 보이지 않았다.

판단:

- 파일 변경은 되었지만 렌더링 변경은 실패했다.
- TTF 내부 family 이름은 `NeoDunggeunmo`로 확인되어 이름 불일치 가능성은 낮다.
- 기존 설정값 또는 컴포넌트 스타일이 기본 font stack 변경을 우회하는 것으로 판단했다.

## 2026-06-29 - NeoDunggeunmo force CSS 실험

목표:

- `index.html`에서 `#root` 하위 텍스트에 `font-family`를 강제해 실제 렌더링 변경 가능성을 확인한다.

결과:

- force CSS 적용 후 게임 전체 UI가 NeoDunggeunmo로 바뀌었다.
- Hacknet 화면, floating script window, ASCII 대시보드까지 일관되게 픽셀 폰트 분위기가 적용되었다.

스크린샷:

![폰트 변경](../screenshot/%ED%8F%B0%ED%8A%B8%EB%B3%80%EA%B2%BD.png)

판단:

- force CSS는 성공했다.
- 처음에는 전체 UI 폰트 변경이 과하다고 판단해 `JetBrainsMono, NeoDunggeunmo, "Courier New", monospace` fallback 순서를 실험 후보로 정리했다.
- 이후 스크린샷을 다시 보고, NeoDunggeunmo의 영문/숫자까지 Bitburner 분위기에 잘 맞는다고 판단했다.
- 현재 기본 후보는 전체 UI NeoDunggeunmo 적용이다.
- 단, 긴 코드 편집 작업이 많은 Monaco 에디터는 추후 예외 처리 후보로 남긴다.

관련 문서:

- `docs/07_font_experiment.md`
- `patches/font_neodgm_experiment.json`

## 현재 임시 결론

- 텍스트 한글화는 번들 직접 치환으로 작동한다.
- 폰트는 단순 font stack 치환만으로는 실제 렌더링에 반영되지 않을 수 있다.
- `index.html` force CSS는 실제 렌더링 변경에 성공했다.
- Phase 1 패처는 문자열 치환과 폰트 패치를 별도 patchId로 분리해야 한다.
- 폰트 패치는 전체 UI 적용을 기본값으로 두되, 에디터 예외 처리를 옵션으로 둔다.

## 2026-06-29 - Augmentation 효과 라벨 소형 패치

목표:

- Augmentation 이름이나 내부 multiplier 키는 건드리지 않는다.
- `src/Augmentation/Augmentation.ts`에서 생성되는 효과 설명 라벨만 번역한다.
- 광범위한 `hacking skill` 치환 대신 minified bundle의 Augmentation 전용 조각만 치환한다.

적용한 번역:

- `Effects:` -> `효과:`
- `all skills` -> `모든 스킬`
- `hacking skill` -> `해킹 스킬`
- `combat skills` -> `전투 스킬`
- `exp for all skills` -> `모든 스킬 경험치`
- `hacking exp` -> `해킹 경험치`
- `combat exp` -> `전투 경험치`

검증:

- 각 source 조각은 적용 전 정확히 1회 매치되었다.
- `scripts/apply-patch.ps1 -Patch patches/augmentation_effects_small.json -Apply`로 적용했다.
- 적용 후 source 조각 7개는 모두 0회, target 조각 7개는 모두 1회 확인했다.
- `patch-state.json`에 `augmentation_effects_small` applied entry 7개가 기록되었다.

화면 검증 스크린샷:

성공 사례 1: `CRTX42-AA`

![CRTX42-AA 효과 라벨 성공](../screenshot/augmentation_crtx42_success.png)

관찰:

- `Effects:`가 `효과:`로 정상 표시된다.
- `hacking skill`이 `해킹 스킬`로 표시된다.
- `hacking exp`가 `해킹 경험치`로 표시된다.
- Augmentation 이름 `CRTX42-AA`와 설명문은 원문 그대로 유지되었다.
- 줄바꿈, 숫자, `%` 포맷은 깨지지 않았다.

성공 사례 2: `Neurotrainer I`

![Neurotrainer I 모든 스킬 경험치 성공](../screenshot/augmentation_neurotrainer_success.png)

관찰:

- `exp for all skills`가 `모든 스킬 경험치`로 정상 표시된다.
- `%`와 수치 포맷은 유지되었다.
- 전체 UI NeoDunggeunmo 폰트와 한글 라벨 조합이 자연스럽다.
- 이 화면은 이번 패치가 “공통 경험치 라벨”에도 적용된다는 증거다.

부분 성공/남은 범위 1: synaptic potentiation 계열

![Synaptic potentiation 부분 성공](../screenshot/augmentation_synaptic_partial.png)

관찰:

- `Effects:` -> `효과:` 성공
- `hacking exp` -> `해킹 경험치` 성공
- `faster hack(), grow(), and weaken()`은 영어로 남았다.
- `hack() success chance`도 영어로 남았다.

판단:

- 이 화면은 패치 실패가 아니라 “1차 scope 밖 문자열”이 남은 사례다.
- 이번 manifest는 `src/Augmentation/Augmentation.ts`의 스킬/경험치 공통 라벨만 목표로 했다.
- `faster hack(), grow(), and weaken()`와 `hack() success chance`는 같은 함수의 다른 multiplier 라벨로 보이며, 다음 Augmentation 패치에서 별도 expectedCount로 다루는 것이 맞다.
- API 표기인 `hack()`, `grow()`, `weaken()`은 유지해야 한다.

부분 성공/남은 범위 2: Synthetic Nerve Enhancement 계열

![Synthetic nerve 부분 성공](../screenshot/augmentation_synthetic_nerve_partial.png)

관찰:

- `Effects:` -> `효과:` 성공
- `dexterity skill`, `agility skill`은 영어로 남았다.

판단:

- 이 역시 패치 실패가 아니라 의도적으로 남겨둔 개별 스킬 라벨이다.
- 1차 manifest는 `hacking skill`, `combat skills`, `all skills` 같은 대표/공통 라벨만 처리했다.
- 다음 후보는 `strength skill`, `defense skill`, `dexterity skill`, `agility skill`, `charisma skill` 및 각 exp 라벨이다.
- 단순 `dexterity skill` broad 치환은 다른 문맥을 건드릴 수 있으므로, 이번과 같이 `r(e.dexterity-1)} dexterity skill` 뒤에 template literal 종료가 붙는 Augmentation 전용 minified 조각으로 잡아야 한다.

실패/한계 정리:

- 실패한 것은 패처나 적용 절차가 아니라 번역 범위다.
- source 0회/target 1회 검증은 통과했으므로 manifest에 들어간 7개 조각은 정상 적용되었다.
- 화면 검증 결과, 이번 patch scope에 포함되지 않은 개별 효과 라벨이 남아 있음을 확인했다.
- 다음 패치에서는 “Augmentation 효과 라벨 2차”로 개별 스킬/경험치/해킹 액션 라벨을 추가한다.

다음 후보:

- `strength skill` -> `힘 스킬`
- `defense skill` -> `방어 스킬`
- `dexterity skill` -> `민첩 스킬`
- `agility skill` -> `기동 스킬`
- `charisma skill` -> `카리스마 스킬`
- `strength exp` -> `힘 경험치`
- `defense exp` -> `방어 경험치`
- `dexterity exp` -> `민첩 경험치`
- `agility exp` -> `기동 경험치`
- `charisma exp` -> `카리스마 경험치`
- `faster hack(), grow(), and weaken()` -> `hack(), grow(), weaken() 속도 증가`
- `hack() success chance` -> `hack() 성공 확률`

## 2026-06-29 - Augmentation 효과 라벨 2차 패치

목표:

- 1차 패치 후 스크린샷에서 남은 개별 효과 라벨을 처리한다.
- 같은 영어 문장이 여러 문맥에 존재하는 경우 broad 치환을 피한다.
- `hack()`, `grow()`, `weaken()` 같은 API 표기는 유지한다.

적용한 번역:

- `strength skill` -> `힘 스킬`
- `defense skill` -> `방어 스킬`
- `dexterity skill` -> `민첩 스킬`
- `agility skill` -> `기동 스킬`
- `charisma skill` -> `카리스마 스킬`
- `strength exp` -> `힘 경험치`
- `defense exp` -> `방어 경험치`
- `dexterity exp` -> `민첩 경험치`
- `agility exp` -> `기동 경험치`
- `charisma exp` -> `카리스마 경험치`
- `faster hack(), grow(), and weaken()` -> `hack(), grow(), weaken() 속도 증가`
- `hack() success chance` -> `hack() 성공 확률`

통제 확인:

- 개별 스킬/경험치 라벨 10개는 적용 전 각각 정확히 1회 매치되었다.
- `hack() success chance`도 Augmentation 전용 조각에서 정확히 1회 매치되었다.
- `faster hack(), grow(), and weaken()` 원문은 전체 번들 기준 3회였다.
- 3회 중 하나는 Augmentation 효과, 하나는 다른 효과 템플릿, 하나는 IPvGO 보너스 설명이었다.
- 따라서 실제 source는 `r(e.hacking_speed-1)} faster hack(), grow(), and weaken()`처럼 Augmentation 전용 multiplier 문맥을 포함해 잡았다.

적용 결과:

- `scripts/apply-patch.ps1 -Patch patches/augmentation_effects_individual.json` dry-run 통과
- `scripts/apply-patch.ps1 -Patch patches/augmentation_effects_individual.json -Apply` 적용 성공
- 적용 후 12개 source 조각은 모두 0회 확인
- 적용 후 12개 target 조각은 모두 1회 확인
- `patch-state.json`에 `augmentation_effects_individual` applied entry가 기록되었다.

판단:

- 1차 스크린샷에서 보였던 `dexterity skill`, `agility skill`, `faster hack(), grow(), and weaken()`, `hack() success chance` 잔류는 패치 범위 문제였고, 2차 manifest로 해결했다.
- 실제 게임 화면 재검증 스크린샷으로 2차 패치 반영을 확인했다.
- 다음 단계는 Terminal analyze 라벨 패치다.

## 2026-06-29 - Augmentation 효과 라벨 2차 화면 검증

목표:

- 2차 패치가 실제 게임 UI에 반영되는지 확인한다.
- 1차에서 영어로 남았던 라벨이 사라졌는지 확인한다.
- 숫자, `%`, API 표기, 줄바꿈이 깨지지 않는지 본다.

검증 스크린샷 1: Synaptic potentiation 계열

![Synaptic potentiation 2차 성공](../screenshot/augmentation_synaptic_success.png)

관찰:

- `효과:`가 유지된다.
- `해킹 경험치`가 유지된다.
- 1차에서 영어로 남았던 `faster hack(), grow(), and weaken()`가 `hack(), grow(), weaken() 속도 증가`로 바뀌었다.
- 1차에서 영어로 남았던 `hack() success chance`가 `hack() 성공 확률`로 바뀌었다.
- `hack()`, `grow()`, `weaken()` API 표기는 그대로 보존되었다.

검증 스크린샷 2: Synthetic Nerve Enhancement 계열

![Synthetic nerve 2차 성공](../screenshot/augmentation_synthetic_nerve_success.png)

관찰:

- `dexterity skill`이 `민첩 스킬`로 바뀌었다.
- `agility skill`이 `기동 스킬`로 바뀌었다.
- 설명문과 Augmentation 이름은 원문 그대로 유지되었다.
- 효과 라벨만 좁게 번역하는 정책이 지켜졌다.

검증 스크린샷 3: Cranial Signal Processors - Gen II

![Cranial Signal Processors 2차 성공](../screenshot/augmentation_cranial_signal_processors_success.png)

관찰:

- `해킹 스킬`, `hack(), grow(), weaken() 속도 증가`, `hack() 성공 확률`이 한 화면에서 함께 정상 표시된다.
- 긴 설명문과 효과 목록 사이의 줄간격은 깨지지 않았다.
- 숫자와 `%` 포맷도 유지되었다.

판단:

- Augmentation 효과 라벨 2차 패치는 실제 화면 검증까지 성공했다.
- 1차에서 실패처럼 보였던 항목들은 패치 범위 밖 잔류였고, 2차에서 해결되었다.
- 현재 Augmentation 효과 라벨은 “공통 라벨 + 개별 스킬/경험치 + 해킹 액션 라벨”까지 안정적으로 처리된 상태다.
- 다음 단계는 Terminal analyze 라벨 패치로 이동한다.
