# 조사 상황

## 로컬 설치본 구조

Bitburner 스팀판은 Electron 앱 형태로 설치되어 있다.

주요 파일:

- `bitburner.exe`: Electron 실행 파일
- `resources/app/index.html`: 앱 HTML 엔트리
- `resources/app/dist/vendor.bundle.js`: 외부 라이브러리 번들
- `resources/app/dist/main.bundle.js`: 게임 본체 번들
- `resources/app/dist/main.bundle.js.map`: 원본 TypeScript/TSX 소스가 포함된 소스맵
- `locales/ko.pak`: Chromium/Electron 자체 UI 로케일 파일로 보이며, Bitburner 게임 텍스트 번역 파일은 아니다.

`index.html`에는 `translate="no"`가 지정되어 있다. 브라우저 번역 확장이나 자동 번역에 의존하면 React DOM과 충돌할 수 있으므로 공식적인 패치 방식으로 보기는 어렵다.

## 번역 레이어 상태

현재 설치본에는 게임 전체 UI를 위한 완성된 i18n 레이어가 보이지 않는다. 게임 텍스트는 React/TypeScript 코드 안의 문자열로 넓게 흩어져 있다.

공식 저장소는 `bitburner-official/bitburner-src`이며, 과거 i18n 시작 PR은 있었지만 머지되지 않았다.

참고:

- `https://github.com/bitburner-official/bitburner-src/pull/598`
- `https://github.com/bitburner-official/bitburner-src/issues/2115`
- `https://github.com/bitburner-official/bitburner-src/pull/1505`

## 확인된 번역 후보 위치

사용자가 보여준 화면 기준:

- Hacknet Nodes 설명문: `src/Hacknet/ui/GeneralInfo.tsx`
- Augmentation 설명문: `src/Augmentation/Augmentations.ts`
- Augmentation 효과 문자열: `src/Augmentation/Augmentation.ts`
- Gang 장비 효과 문자열: `src/Gang/GangMemberUpgrade.ts`
- Terminal analyze 스탯 출력: `src/Terminal/Terminal.ts`

소스맵 기준 위치이므로 실제 설치본에서는 `main.bundle.js` 안에 압축/번들된 문자열로 들어 있다.

## 폰트 상태

기본 스타일은 다음과 같다.

```ts
fontFamily: `JetBrainsMono, "Courier New", monospace`
```

설치본에는 JetBrainsMono가 번들되어 있으나 한글 전용 폰트는 없다. 한글은 시스템 fallback으로 보일 수 있지만, 픽셀풍 고정폭 느낌과 줄높이 안정성을 위해 네오둥근모를 명시적으로 적용하는 편이 좋다.

확인된 폰트 파일:

- 원본: `C:\Users\user\Desktop\neodgm.ttf`
- 작업 루트 복사본: `assets\fonts\neodgm.ttf`

## 핵심 판단

전체 한글화는 큰 포크 작업에 가깝다. 하지만 고유명사와 API 식별자를 유지하고 설명문/효과/스탯 라벨만 한글화하는 제한 범위는 현실적이다.
