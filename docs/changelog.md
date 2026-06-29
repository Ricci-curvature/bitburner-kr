# 변경 기록

## 2026-06-29

- `C:\Users\user\bitburner kr` 작업 루트 정리
- 네오둥근모 폰트 `assets\fonts\neodgm.ttf` 복사
- 조사 상황 문서 작성
- 패치 방향 문서 작성
- 단계별 로드맵 작성
- 번역 정책 초안 작성

## Hacknet Nodes intro small patch

- `resources/app/dist/main.bundle.js` 백업 생성
- `Hacknet Nodes` 화면의 소개 설명문 3개만 한국어로 치환
- 고유명사 `Hacknet`, `Hacknet Node`, `Node` 유지
- 검증: 한국어 3개 문자열 발견, 원문 3개 문자열 미검출
- 패치 기록: `patches/hacknet_nodes_intro_small.json`

## 첫 패치 성공 문서화 및 로드맵 갱신

- `docs/05_first_patch_result.md` 추가
- `docs/03_roadmap.md`를 현실적인 실행 순서로 재작성
- `docs/02_patch_direction.md`에 첫 성공 이후 방향 수정 추가
- 다음 우선순위를 자동 패처, 폰트 단독 실험, Augmentation 효과 라벨로 정리

## Phase 1 패처 설계 보강

- `docs/06_patcher_design.md` 추가
- `expectedCount`, dry-run 기본값, `patch-state.json`, `allowRemainingSource` 요구사항 반영
- 로드맵 Phase 1에 패처 필수 안전장치 추가

## GitHub repo 준비

- `Ricci-curvature/bitburner-kr` 저장소 생성을 목표로 로컬 git 저장소화를 준비했다.
- 게임 번들 백업(`backups/*`)과 폰트 원본(`assets/fonts/*`)은 라이선스/배포 리스크 때문에 git 추적에서 제외했다.
- Phase 1 패처는 dry-run 기본값, expected count, patch-state, 원문 잔존 검사 규칙을 필수 안전장치로 둔다.

## NeoDunggeunmo 폰트 실험

- Bitburner 앱 리소스에 `dist/fonts/neodgm.ttf`를 복사했다.
- `index.html`에 `@font-face`를 추가했다.
- `main.bundle.js`의 기본 font stack 4곳을 `NeoDunggeunmo` 우선으로 치환했다.
- README에 첫 Hacknet 한글 출력 스크린샷을 추가했다.

## NeoDunggeunmo 1차 실패 및 force CSS 실험

- 화면 스크린샷 기준 1차 font stack 치환은 실제 화면 폰트 변경으로 이어지지 않았다.
- TTF 내부 family 이름은 `NeoDunggeunmo`로 확인했다.
- `index.html`에 `#root` 하위 텍스트와 입력/코드/Monaco 계열에 대한 `!important` font-family 강제 CSS를 추가했다.

## NeoDunggeunmo fallback 순서 조정

- force CSS 적용 결과 게임 전체 영문/숫자/UI까지 네오둥근모로 바뀌는 것을 확인했다.
- 목적을 한글 glyph 보강으로 좁히기 위해 font stack을 `JetBrainsMono, NeoDunggeunmo, "Courier New", monospace` 순서로 변경했다.
- 이제 영문/숫자는 기존 JetBrainsMono, 한글은 NeoDunggeunmo fallback을 기대한다.

## 폰트 변경 스크린샷 추가

- `screenshot/font_neodgm_success.png`를 추가했다.
- README와 폰트 실험 문서에 force CSS 성공 화면을 연결했다.
- 이 스크린샷은 NeoDunggeunmo가 실제 렌더링에 적용되었지만 전체 UI 폰트까지 바뀐 상태를 기록한다.

## README 실험 로그 분리

- README의 실험 상세와 스크린샷을 `docs/08_experiment_log.md`로 분리했다.
- README는 현재 상태, 문서 링크, 다음 후보 중심으로 축약했다.
- 폰트 전략은 전체 UI NeoDunggeunmo 적용을 기본 후보로 다시 정리했다.

## 전체 UI NeoDunggeunmo 전략 확정 후보

- 스크린샷 검토 후 NeoDunggeunmo의 영문/숫자까지 Bitburner 분위기에 잘 맞는다고 판단했다.
- `font_neodgm_experiment.json`의 기본 target을 `NeoDunggeunmo, JetBrainsMono, "Courier New", monospace`로 되돌렸다.
- 실제 게임 파일도 전체 UI NeoDunggeunmo 우선 순서로 다시 맞췄다.
- Monaco 코드 에디터만 예외 처리할지는 추후 긴 스크립트 편집 화면을 보고 판단한다.

## Phase 1 패처 초안 작성

- `scripts/apply-patch.ps1`와 `scripts/revert-patch.ps1`를 추가했다.
- apply 패처는 dry-run 기본값, `-Apply`, `expectedCount`, `allowRemainingSource`, 이미 적용된 상태 감지를 지원한다.
- 기존 Hacknet manifest와 신규 operations manifest를 모두 읽을 수 있게 했다.
- 라이브 게임 파일 dry-run과 임시 clean GameRoot dry-run을 통과했다.

## Phase 1 apply/revert 통제 검증

- `C:\tmp\bbkr-patcher-apply` clean GameRoot에서 Hacknet 패치와 폰트 패치를 `-Apply`로 실제 적용했다.
- 적용 후 `patch-state.json` 7개 entry 기록을 확인했다.
- 폰트 패치 revert 후 font file 제거, HTML force CSS 제거, 번들 font stack 복구를 확인했다.
- Hacknet 패치 revert 후 원문 복구와 한국어 문장 제거를 확인했다.
- 테스트용 `patch-state.json`은 검증 후 삭제했다.

## Augmentation 효과 라벨 패치 적용

- `patches/augmentation_effects_small.json`을 추가했다.
- broad string 치환 대신 Augmentation 효과 생성 함수의 minified 조각만 대상으로 삼았다.
- `apply-patch.ps1 -Apply`로 실제 적용했고, source 0회/target 1회 검증을 통과했다.
- 이번 패치부터 수동 치환이 아니라 패처 기반 적용 흐름으로 진행했다.

## Augmentation 화면 검증 스크린샷 기록

- Augmentation 효과 라벨 패치 검증 스크린샷 4장을 추가했다.
- `CRTX42-AA`와 `Neurotrainer I`에서 적용 성공을 확인했다.
- Synaptic potentiation 계열과 Synthetic Nerve Enhancement 계열에서 1차 scope 밖 라벨이 영어로 남는 것을 확인했다.
- 남은 라벨은 실패가 아니라 다음 Augmentation 2차 패치 후보로 분리했다.

## Augmentation 효과 라벨 2차 패치 적용

- `patches/augmentation_effects_individual.json`을 추가했다.
- 개별 스킬/경험치 라벨 10개와 해킹 액션 라벨 2개를 Augmentation 전용 minified 조각으로 치환했다.
- `faster hack(), grow(), and weaken()`는 전체 번들에 3회 존재해 broad 치환을 피하고 `e.hacking_speed` 문맥으로 제한했다.
- dry-run 12개 `sourceCount=1`, 적용 후 source 0회/target 1회 검증을 통과했다.

## Augmentation 2차 화면 검증 스크린샷 기록

- `augmentation_synaptic_success.png`, `augmentation_synthetic_nerve_success.png`, `augmentation_cranial_signal_processors_success.png`를 추가했다.
- Synaptic 계열에서 `hack(), grow(), weaken() 속도 증가`와 `hack() 성공 확률` 표시를 확인했다.
- Synthetic Nerve 계열에서 `민첩 스킬`, `기동 스킬` 표시를 확인했다.
- Cranial Signal Processors 계열에서 해킹 스킬/속도/성공 확률 라벨이 함께 정상 표시되는 것을 확인했다.

## Terminal analyze 라벨 패치 적용

- `patches/terminal_analyze_labels.json`을 추가했다.
- Terminal `analyze` 출력 라벨 17개를 analyze 전용 minified 조각으로 치환했다.
- `Backdoor` 라벨은 analyze 함수 안의 2회 출력을 `expectedCount: 2`로 처리했다.
- `N/A`, `YES/NO`, `Open/Closed`, 명령어/API/포트명은 보존했다.
- dry-run, apply, source 0회/target expectedCount 검증, 재 dry-run already-applied 확인을 통과했다.

## Terminal analyze 화면 검증 스크린샷 기록

- `terminal_analyze_home_success.png`를 추가했다.
- Terminal `analyze` 실행 결과에서 조직/권한/Backdoor/해킹/포트 라벨 표시를 확인했다.
- `RAM`, `YES/NO`, `Closed`, `hack()`, `NUKE`, 포트명 보존도 확인했다.

## Hacknet 요약 라벨 패치 적용

- `patches/hacknet_summary_labels.json`을 추가했다.
- Hacknet 요약 박스의 제목/금액/생산 속도 라벨과 Hacknet Node 구매 버튼을 번역했다.
- 5개 source 모두 `expectedCount=1`로 제한했고, 적용 후 source 0회/target 1회 검증을 통과했다.
- `Level:`, `RAM:`, `Cores:`처럼 전역 출현이 많은 라벨은 이번 패치에서 제외했다.

## Hacknet 요약 라벨 화면 검증

- `hacknet_summary_success.png`를 추가했다.
- Hacknet 요약 박스에서 제목, 사용한 돈, 벌어들인 돈, 생산 속도 라벨 표시를 확인했다.
- 금액/초당 생산량 포맷과 NeoDunggeunmo 정렬이 유지되는 것을 확인했다.

## Hacknet Node 카드 라벨 패치 적용

- `patches/hacknet_node_card_labels.json`을 추가했다.
- Hacknet Node 카드의 `Production`, `Level`, `Cores` 라벨과 최대치 버튼 3개를 번역했다.
- `RAM:`은 약어 그대로 보존했다.
- 전역 출현 수가 많은 라벨이라 React minified context 조각으로 제한해 적용했다.

## Hacknet Node 카드 화면 검증

- `hacknet_node_card_success.png`를 추가했다.
- Hacknet Node 카드의 생산량/레벨/코어 라벨과 최대치 버튼 표시를 확인했다.
- `RAM:` 약어, Node 이름, 금액/생산량 포맷 보존을 확인했다.

## Options System 라벨 패치 적용

- `options_system_before.png`를 추가했다.
- `patches/options_system_labels.json`을 추가했다.
- Options System 페이지의 입력/슬라이더/스위치 라벨 11개를 번역했다.
- 왼쪽 탭, Options 제목, 하단 작업 버튼은 다음 패치로 분리했다.

## Options 창 확장 및 툴팁 보정

- Options 라벨/탭/하단 작업 버튼/Key Binding 보조 텍스트 패치 manifest를 추가했다.
- 화면 스크린샷에서 확인된 미번역 툴팁과 설명문을 `options_tooltip_completion.json`, `options_tooltip_final_sweep.json`으로 보정했다.
- 소스맵 줄바꿈 원문과 실제 minified 번들 문자열이 달라 `expectedCount=0`이 발생한 케이스를 기록하고, 실제 literal count 기반으로 재작성했다.
- System, Gameplay, Interface, Numeric Display, Misc, Remote API, Key Binding의 주요 Options 문구를 정적 검증 기준으로 완료했다.
- Options scope 밖에 남은 Dark Web/Active Scripts 툴팁은 다음 후보로 분리했다.

## Options 최종 잔여 4곳 보정

- `patches/options_final_visual_fixes.json`을 추가했다.
- Interface 시간 예시의 영어 단위를 한국어 단위로 바꿨다.
- Numeric Display 통화 기호 위치 툴팁을 번역했다.
- Key Binding 표시명 매핑에 Faction/Augmentation/Achievements/Options/ScriptEditor 계열을 추가했다.
- 실험 로그의 스크린샷 표현을 `스크린샷`으로 통일하고, 중간 잔여 기록과 최종 보정 기록을 분리했다.

## Options 완료 화면 확인

- `options_interface_final_success.png`를 추가했다.
- Options 화면의 한글 렌더링이 누락 없이 완료된 것을 기록했다.
- 실험 로그와 README의 화면 확인 관련 문서 서술을 정리했다.
- Options 묶음을 화면 확인 기준 완료 상태로 업데이트했다.
## Active Scripts 라벨/텍스트 패치 적용

- `patches/active_scripts_labels.json`과 `patches/active_scripts_texts.json`을 추가했다.
- Active Scripts 탭, 오류 모달 숨기기, 모든 스크립트 종료 버튼/툴팁을 번역했다.
- 소개문, 총 생산, 페이지당 표시 수, 표시 범위, 생산 통계 라벨을 2차로 보정했다.
- `active_scripts_partial_residual.png`와 `active_scripts_success.png`를 추가했다.
- 시간 단위 formatter는 전역 영향 가능성이 있어 별도 후보로 남겼다.

## Dark Net 화면 라벨/툴팁 패치 적용

- `patches/darknet_tooltips.json`을 추가했다.
- 처음 잡은 `DarknetDev` 개발 패널 문맥은 실제 화면이 아니어서 revert 후 실제 `DarkWeb` UI 문맥으로 재작성했다.
- Dark Net 제목, 서버 카드 상태, 매력 라벨, 검색 UI, 문서 버튼, 주요 상태 툴팁을 번역했다.
- `darknet_success.png`를 추가하고 화면 검증 완료로 기록했다.
- `Logs scraped via`, `Hint:`는 2회 출현 문구라 별도 보강 후보로 남겼다.

## Monaco 코드 에디터 폰트 예외 처리

- `patches/font_monaco_exception.json`을 추가했다.
- 전체 UI NeoDunggeunmo 적용은 유지하고, Monaco Script Editor/diff editor 내부만 기존 코딩 폰트 계열로 되돌렸다.
- `font_monaco_exception_success.png`를 추가하고 화면 검증 완료로 기록했다.

## Faction work/메인/짧은 소개문 패치 적용

- `patches/faction_work_labels.json`, `patches/faction_main_residual_labels.json`, `patches/faction_info_descriptions_small.json`을 추가했다.
- Faction work 안내문, 작업 카드, 작업 진행/종료 라벨을 번역했다.
- Faction 메인 화면의 특수 캠페인, 기부 해금, Reputation/Favor 툴팁, 짧은 소개문을 보정했다.
- `faction_sector12_info_success.png`, `faction_slum_snakes_work_success.png`, `faction_favor_tooltip_success.png`를 추가하고 화면 검증 완료로 기록했다.

## Faction Augmentations 구매 화면 패치 적용

- `patches/faction_augmentations_purchase_labels.json`을 추가했다.
- Faction Augmentations 구매 화면 제목, 상단 설명문, 정렬/검색 UI, 구매/보유 버튼, 평판 비용 단위, 선행 조건/획득처 툴팁을 번역했다.
- 구매 확인 모달 문구와 구매 버튼을 번역했다.
- `faction_augmentations_purchase_success.png`, `faction_augmentations_prereq_tooltip_success.png`를 추가하고 화면 검증 완료로 기록했다.

## Documentation 홈/Beginner's guide 1차 패치 적용

- `patches/documentation_home_toc.json`, `patches/documentation_beginners_intro_first_steps.json`을 추가했다.
- Documentation 홈/목차의 섹션명과 링크 라벨을 번역했다.
- Beginner's guide 제목, 참고문, 소개, `First Steps` 섹션 전체를 번역했다.
- markdown 링크 경로, 코드 span, 명령어, 파일명, 서버명은 보존했다.
- 같은 `main.bundle.js`를 수정하는 manifest는 병렬 적용 시 덮어쓰기 위험이 있어 순차 적용 원칙을 실험 로그에 기록했다.
- `documentation_beginner_intro_first_steps_success.png`, `documentation_home_advanced_success.png`, `documentation_home_resources_success.png`를 추가하고 화면 검증 완료로 기록했다.

## Documentation Beginner's guide 전체 번역 패치 적용

- `patches/documentation_beginners_creating_first_script.json`, `patches/documentation_beginners_running_scripts.json`을 추가했다.
- `patches/documentation_beginners_hacking_level_cloud_servers.json`, `patches/documentation_beginners_income_sources.json`, `patches/documentation_beginners_level50_cybersec_servers.json`, `patches/documentation_beginners_final_sections.json`을 추가했다.
- Beginner's guide의 `Creating our First Script` 이후 마지막 `Random Tips`까지 전체 본문을 번역했다.
- 코드 블록, 명령어, API명, 파일명, 서버명, markdown 링크 경로는 보존했다.
- 후반부 대형 문서 패치에서 JS 문자열 quote escaping 누락으로 게임 첫 실행 검은화면 문제가 발생했고, `node --check`와 revert/apply 통제 실험으로 원인을 확인했다.
- manifest target의 큰따옴표/작은따옴표 escaping을 보정한 뒤 후반부 4개 manifest를 순차 재적용했다.
- 각 후반부 manifest 적용 직후 `node --check resources/app/dist/main.bundle.js`를 통과했고, 재 dry-run에서 모두 `already-applied targetCount=1`을 확인했다.
- `documentation_beginner_creating_first_script_top_success.png`, `documentation_beginner_creating_first_script_code_success.png`, `documentation_beginner_final_next_steps_success.png`, `documentation_beginner_final_random_tips_success.png`를 추가하고 화면 검증 완료로 기록했다.
