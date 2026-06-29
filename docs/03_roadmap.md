# 현실적인 로드맵

## 현재 상태

여러 화면에서 소형 패치 -> 화면 검증 -> 문서화 -> 커밋 흐름이 안정적으로 반복되고 있다.

완료한 것:

- `Hacknet Nodes` 소개 설명문 3개 치환
- Phase 1 패처와 revert 통제 검증
- NeoDunggeunmo 전체 UI 폰트 적용
- Monaco 코드 에디터 폰트 예외 처리
- Augmentation 효과 라벨 1차/2차
- Terminal `analyze` 라벨
- Hacknet 요약/Node 카드 라벨
- Options 라벨/버튼/주요 툴팁
- Active Scripts 라벨/설명문/생산 통계 텍스트
- Dark Net 화면 라벨/상태/주요 툴팁
- Faction work 라벨/메인 잔여/짧은 소개문
- Faction Augmentations 구매 화면 라벨/설명문
- Documentation 홈/목차와 Beginner's guide 상단/`First Steps` 섹션
- 고유명사 유지 전략 검증
- 번들 직접 치환 방식 검증
- 패처 기반 dry-run -> apply -> 재 dry-run 검증 흐름 정착

남은 주요 후보:

- Dark Net 인증/상세 모달 잔여
- Faction 긴 lore/rumor 문구 sweep
- Documentation 섹션 단위 확장
- Hacknet 관련 나머지 설명/툴팁
- 공용 시간 단위 formatter
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

1. Documentation `Creating our First Script` 섹션 단위 확장
2. Dark Net 인증/상세 모달 잔여
3. Faction 긴 lore/rumor 문구 sweep
4. Hacknet 관련 나머지 설명/툴팁
5. 공용 시간 단위 formatter
6. Gang 설명/툴팁
7. Work/Class 결과 문구
8. Tutorial 설명문

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

- Augmentation 효과 라벨 2차 패치로 개별 스킬/경험치/해킹 액션 라벨 추가 완료
- 이후 Terminal analyze 라벨 패치로 이동

## Phase 3 진행 메모 - 2차

2026-06-29 기준 Augmentation 효과 라벨 2차 패치를 적용했다.

구현된 것:

- `patches/augmentation_effects_individual.json`
- 개별 스킬 라벨 5개 치환: 힘, 방어, 민첩, 기동, 카리스마
- 개별 경험치 라벨 5개 치환: 힘, 방어, 민첩, 기동, 카리스마
- 해킹 액션 라벨 2개 치환: `hack(), grow(), weaken() 속도 증가`, `hack() 성공 확률`

검증한 것:

- dry-run에서 12개 operation 모두 `sourceCount=1` 확인
- 적용 후 각 source 조각 0회, target 조각 1회 확인
- `faster hack(), grow(), and weaken()`는 전체 번들에 3회 있었으므로 Augmentation 전용 `e.hacking_speed` 문맥으로 좁혀 적용

다음 확인:

- Synaptic potentiation 계열과 Synthetic Nerve Enhancement 계열 실제 표시 확인 완료
- Cranial Signal Processors 계열에서 해킹 스킬/속도/성공 확률 동시 표시 확인 완료
- 다음 단계는 Terminal analyze 라벨 패치

## Phase 4 진행 메모

2026-06-29 기준 Terminal `analyze` 라벨 패치를 적용했다.

구현된 것:

- `patches/terminal_analyze_labels.json`
- `finishAnalyze` 출력 라벨 17개 치환
- 조직/권한/RAM 보조 라벨, 해킹 난이도/확률/시간, 서버 자금, NUKE 포트 라벨 처리
- `hack()`, `backdoor`, `NUKE`, 포트명, `RAM`, `N/A`, `YES/NO`, `Open/Closed`는 보존

검증한 것:

- dry-run에서 `Backdoor` 라벨은 의도대로 2회, 나머지는 모두 1회 매치
- 적용 후 각 source 조각 0회 확인
- 적용 후 각 target 조각은 expectedCount 이상 확인
- 재실행 dry-run에서 17개 operation 모두 `already-applied` 확인
- 현재 Bitburner 3.0.1 번들에는 `Time to grow`, `Time to weaken` analyze 출력 라벨이 없어 이번 scope에서 제외

다음 확인:

- Terminal에서 `analyze` 실행 화면 확인 완료
- home 서버 기준 조직/권한/Backdoor/해킹/포트 라벨 정상 표시 확인 완료
- `terminal_analyze_home_success.png` 스크린샷을 실험 로그에 연결 완료

## Phase 5 진행 메모 - Hacknet 요약 라벨

2026-06-29 기준 Hacknet 화면의 요약 박스와 구매 버튼 라벨 소형 패치를 적용했다.

구현된 것:

- `patches/hacknet_summary_labels.json`
- `Hacknet Summary` -> `Hacknet 요약`
- `Money Spent:` -> `사용한 돈:`
- `Money Produced:` -> `벌어들인 돈:`
- `Production Rate:` -> `생산 속도:`
- `Purchase Hacknet Node -` -> `Hacknet Node 구매 -`

검증한 것:

- dry-run에서 5개 operation 모두 `sourceCount=1` 확인
- 적용 후 각 source 0회, target 1회 확인
- 재실행 dry-run에서 5개 operation 모두 `already-applied` 확인

보류한 것:

- `Level:`, `RAM:`, `Cores:`는 전체 번들 출현 수가 많아 이번 범위에서 제외했다.
- `MAX LEVEL`, `MAX RAM`, `MAX CORES`도 여러 Hacknet Node/Server 문맥이 섞일 수 있어 별도 문맥 패치로 분리한다.

다음 확인:

- 실제 Hacknet Nodes 화면에서 요약 박스 표시 확인 완료
- `hacknet_summary_success.png` 스크린샷을 실험 로그에 연결 완료
- 구매 버튼은 화면 하단이 일부만 보이는 상태라 다음 넓은 스크린샷에서 추가 확인한다.


## Phase 5 진행 메모 - Hacknet Node 카드 라벨

2026-06-29 기준 Hacknet Node 카드의 표 라벨과 최대치 버튼 라벨 소형 패치를 적용했다.

구현된 것:

- `patches/hacknet_node_card_labels.json`
- `Production:` -> `생산량:`
- `Level:` -> `레벨:`
- `Cores:` -> `코어:`
- `MAX LEVEL` -> `최대 레벨`
- `MAX RAM` -> `최대 RAM`
- `MAX CORES` -> `최대 코어`

보존한 것:

- `RAM:`은 약어 가독성이 좋아 번역하지 않았다.
- Hacknet Node 이름과 금액/생산량 포맷은 건드리지 않았다.

검증한 것:

- broad 출현 수는 `Production:` 16회, `Level:` 179회, `RAM:` 48회, `Cores:` 27회라 직접 치환하지 않았다.
- React minified context 조각 기준으로 6개 source가 각각 정확히 1회만 매치되는 것을 확인했다.
- dry-run, apply, 적용 후 source 0회/target 1회, 재 dry-run already-applied 확인을 통과했다.

다음 확인:

- 실제 Hacknet Nodes 화면에서 Node 카드 라벨과 최대치 버튼 표시를 확인한다.
- 스크린샷이 추가되면 실험 로그에 화면 검증 결과를 이어 쓴다.

## Phase 5 진행 메모 - Options System 라벨

2026-06-29 기준 Options 화면의 System 페이지 라벨 1차 패치를 적용했다.

구현된 것:

- `patches/options_system_labels.json`
- `Autoexec Script + Args` -> `Autoexec 스크립트 + 인수`
- `Recently killed scripts size` -> `최근 종료 스크립트 크기`
- `Netscript log size` -> `Netscript 로그 크기`
- `Netscript port size` -> `Netscript 포트 크기`
- `Terminal capacity` -> `터미널 용량`
- `Autosave interval (s)` -> `자동 저장 간격 (초)`
- `Tail render interval (ms)` -> `Tail 렌더 간격 (ms)`
- `Suppress Auto-Save Game Toast` -> `자동 저장 알림 숨기기`
- `Suppress Auto-Save Disabled Warning` -> `자동 저장 비활성화 경고 숨기기`
- `Save game on file save` -> `파일 저장 시 게임 저장`
- `Exclude Running Scripts from Save` -> `저장에서 실행 중인 스크립트 제외`

보존한 것:

- `Autoexec`, `Netscript`, `Tail`은 게임 내 고유 용어에 가까워 유지했다.
- Options 제목, 왼쪽 탭, 하단 작업 버튼은 다음 패치로 분리했다.

검증한 것:

- `label:`/`text:` 문맥으로 제한한 11개 source가 각각 정확히 1회만 매치되는 것을 확인했다.
- dry-run, apply, 적용 후 target 1회, 재 dry-run already-applied 확인을 통과했다.
- `Recently killed scripts size`는 API 문서에도 등장하므로 `label:` 문맥으로 제한했고 `allowRemainingSource: true`로 기록했다.

다음 확인:

- 실제 Options > System 화면에서 라벨 길이와 스위치 줄바꿈을 확인한다.
- 화면 검증 스크린샷을 추가하면 Options System 1차 패치를 완료로 본다.

## Phase 5 진행 메모 - Options 창 확장 및 설명문 sweep

2026-06-29 기준 Options 창의 라벨/버튼/주요 설명문 패치를 적용했다.

구현된 것:

- `patches/options_remaining_texts.json`
- `patches/options_sidebar_buttons.json`
- `patches/options_keybinding_texts.json`
- `patches/options_tooltip_completion.json`
- `patches/options_tooltip_final_sweep.json`
- Options 루트 제목, 탭 표시명, 하단 작업 버튼, Key Binding 보조 텍스트와 동작 이름 표시 매핑
- System/Gameplay/Interface/Numeric Display/Misc/Remote API 주요 툴팁 설명문

검증한 것:

- 각 manifest는 dry-run을 먼저 통과한 뒤 `-Apply`로 적용했다.
- 적용 후 재 dry-run에서 모든 operation이 `already-applied` 상태임을 확인했다.
- 화면 스크린샷에서 발견된 영어 잔여 문구는 실제 번들 literal count 기반으로 다시 잡아 보정했다.
- Options 내부에서 확인된 `If this is set` 계열 잔여 설명문은 0회로 만들었다.
- 남은 `If this is set` 3건은 Dark Web/Active Scripts 문맥으로 Options scope 밖이다.

다음 확인:

- 게임을 새로고침하고 Options 전 탭의 시각 검증 스크린샷을 추가한다.
- Options 화면에서 길이가 과한 한국어 툴팁이 있으면 표현을 줄인다.
- 이후 Phase 6 후보였던 Active Scripts 라벨 소형 패치는 후속 Phase 6에서 처리했다.

## Phase 5 진행 메모 - Options 최종 시각 잔여 보정

2026-06-29 화면 확인 기준 Options에서 남은 4곳을 추가 보정했다.

구현된 것:

- `patches/options_final_visual_fixes.json`
- Interface 시간 예시의 영어 시간 단위 한국어화
- Numeric Display 통화 기호 위치 툴팁 한국어화
- Key Binding 동작 이름 매핑 보강: Faction/Augmentation/Achievements/Options/ScriptEditor 계열

검증한 것:

- dry-run, apply, 재 dry-run already-applied 확인을 통과했다.
- 기존 영어/내부 action id source는 0회, target은 1회 확인했다.

다음 확인:

- Options 화면을 새로고침해 최종 시각 확인 스크린샷을 남긴다.
- 다음 패치 후보였던 Active Scripts 라벨은 후속 Phase 6에서 처리했다.

## Phase 5 완료 메모 - Options 창

2026-06-29 기준 Options 창 묶음은 화면 확인까지 완료했다.

완료 기준:

- System, Gameplay, Interface, Numeric Display, Misc, Remote API, Key Binding 탭의 주요 라벨/버튼/툴팁 설명문 한글 렌더링 확인
- 최종 잔여 4곳 보정 후 새 잔여 문구 없음
- 길이 문제나 UI 깨짐 없음
- `options_interface_final_success.png`를 실험 로그에 연결

다음 단계:

- Active Scripts 라벨과 Dark Net 화면 라벨/툴팁은 후속 Phase 6/7에서 처리했다.

## Phase 6 완료 메모 - Active Scripts

구현된 것:

- `patches/active_scripts_labels.json`
- `patches/active_scripts_texts.json`
- Active Scripts 탭, 오류 모달 숨기기, 모든 스크립트 종료 버튼/툴팁
- Active Scripts 소개문, 총 생산, 페이지당 표시 수, 표시 범위, 생산 통계 라벨

검증한 것:

- 두 manifest 모두 dry-run, apply, 재 dry-run already-applied 확인을 통과했다.
- 1차 화면 확인에서 남은 설명문/통계 텍스트를 2차 manifest로 보정했다.
- 최종 화면에서 주요 Active Scripts 라벨과 생산 통계 텍스트의 한글 렌더링을 확인했다.

남은 것:

- `hours`, `minutes`, `seconds` 같은 시간 단위는 공용 formatter 출력으로 보이므로 별도 통제 실험으로 분리한다.
- Faction work 라벨은 후속 Phase 9에서 처리했다.

## Phase 7 완료 메모 - Dark Net 화면

구현된 것:

- `patches/darknet_tooltips.json`
- Dark Net 제목, 서버 카드 상태, 매력 라벨, 검색 UI, 문서 버튼
- 데이터 파일/실행 스크립트/보상 캐시/불안정성/백도어 관련 주요 툴팁
- 비밀번호 인증 모달과 서버 상세 모달 일부 라벨

검증한 것:

- 처음 잡은 `DarknetDev` 문맥은 실제 화면이 아니어서 revert 후 폐기했다.
- 실제 `DarkWeb` UI 문맥으로 manifest를 재작성했다.
- 최종 30개 operation이 dry-run, apply, 재 dry-run already-applied 확인을 통과했다.
- `darknet_success.png`에서 제목, 카드 상태, `매력`, 검색 placeholder, 문서 버튼 한글 렌더링을 확인했다.

남은 것:

- `Logs scraped via`, `Hint:`는 2회 출현 문구라 별도 보강 후보로 둔다.
- Faction work 라벨은 후속 Phase 9에서 처리했다.



## Phase 8 완료 메모 - Monaco 코드 에디터 폰트 예외

구현된 것:

- `patches/font_monaco_exception.json`
- 전체 UI NeoDunggeunmo 유지
- Monaco Script Editor와 Monaco diff editor 내부만 `JetBrainsMono, "Courier New", monospace`로 override

검증한 것:

- dry-run에서 `index.html` anchor 1회 확인
- apply 후 재 dry-run `already-applied` 확인
- Script Editor 화면에서 코드 본문이 기존 코딩 폰트 계열로 표시되는 것을 확인했다.

남은 것:

- Faction work 라벨과 Faction Augmentations 구매 화면은 후속 Phase 9/10에서 처리했다.

## Phase 9 완료 메모 - Faction work/메인/짧은 소개문

구현된 것:

- `patches/faction_work_labels.json`
- `patches/faction_main_residual_labels.json`
- `patches/faction_info_descriptions_small.json`
- Faction work 안내문과 작업 카드 3종
- Faction 메인 화면의 특수 캠페인, 기부 해금, Reputation/Favor 툴팁
- Sector-12, Tetrads 등 짧은 Faction 소개문과 적대 관계 라벨

검증한 것:

- 세 manifest 모두 dry-run, apply, 재 dry-run already-applied 확인을 통과했다.
- `faction_sector12_info_success.png`, `faction_slum_snakes_work_success.png`, `faction_favor_tooltip_success.png`에서 화면 렌더링을 확인했다.

남은 것:

- 긴 Faction lore/rumor 문구는 별도 sweep으로 분리한다.

## Phase 10 완료 메모 - Faction Augmentations 구매 화면

구현된 것:

- `patches/faction_augmentations_purchase_labels.json`
- Faction Augmentations 구매 화면 제목, 상단 설명문, 가격/평판 배율, 정렬/검색 UI
- 구매/보유 버튼, 평판 비용 단위, 선행 조건 라벨/툴팁, 획득처 툴팁
- 구매 확인 모달 문구와 구매 버튼

검증한 것:

- dry-run에서 15개 operation이 expected count로 통과했다.
- 적용 후 재 dry-run에서 15개 operation 모두 already-applied로 확인했다.
- `faction_augmentations_purchase_success.png`, `faction_augmentations_prereq_tooltip_success.png`에서 화면 렌더링을 확인했다.

남은 것:

- 개별 Augmentation lore 설명문과 Grafting 구매 화면은 별도 manifest로 분리한다.
- 다음 후보는 Documentation 섹션 단위 확장, Dark Net 인증/상세 모달 잔여, Faction 긴 lore/rumor 문구 sweep이다.

## Phase 11 완료 메모 - Documentation 홈/Beginner's guide 1차

구현된 것:

- `patches/documentation_home_toc.json`
- `patches/documentation_beginners_intro_first_steps.json`
- Documentation 홈/목차의 제목, 섹션명, 링크 라벨
- Beginner's guide 제목, 참고문, 소개, `First Steps` 섹션 전체

검증한 것:

- 두 manifest 모두 dry-run expected count를 통과했다.
- 적용 후 재 dry-run에서 두 manifest 모두 already-applied로 확인했다.
- 대표 원문 `# Documentation`, `Getting Started Guide for Beginner Programmers`, `## First Steps`, `Beginner's guide](help/getting_started.md)`는 source 0회, target 1회로 확인했다.
- `documentation_beginner_intro_first_steps_success.png`, `documentation_home_advanced_success.png`, `documentation_home_resources_success.png`에서 화면 렌더링을 확인했다.

운영 메모:

- Documentation markdown은 모듈 단위 문자열로 들어 있어 섹션 단위 패치가 현실적이다.
- 같은 `main.bundle.js`를 수정하는 manifest는 병렬 apply 시 마지막 writer가 앞선 변경을 덮을 수 있으므로 순차 적용한다.

남은 것:

- Beginner's guide의 `Creating our First Script` 섹션부터 이어서 섹션 단위로 확장한다.
