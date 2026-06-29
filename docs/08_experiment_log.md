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
