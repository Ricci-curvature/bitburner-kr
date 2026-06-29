# 첫 소형 패치 결과

## 결과 요약

`Hacknet Nodes` 화면의 소개 설명문 3개를 한국어로 치환했고, 게임 재시작 후 정상 표시를 확인했다.

이번 실험의 의미:

- `main.bundle.js` 직접 치환 방식이 실제 스팀 설치본에서 동작했다.
- React 렌더링 오류 없이 긴 한국어 문장이 표시됐다.
- 고유명사 `Hacknet`, `Hacknet Node`, `Node`를 유지해도 문맥상 어색하지 않았다.
- 한글 폰트를 아직 명시 적용하지 않았는데도 표시 자체는 정상이다.
- 작은 화면 단위 패치 후 직접 확인하는 방식이 유효하다.

## 적용 범위

대상 화면:

- `Hacknet Nodes`

대상 원본 위치:

- 소스맵 기준: `webpack:///./src/Hacknet/ui/GeneralInfo.tsx`
- 설치본 기준: `D:\SteamLibrary\steamapps\common\Bitburner\resources\app\dist\main.bundle.js`

치환 대상:

1. Hacknet 네트워크 소개 문단
2. Hacknet Node 구매 설명 문단
3. Hacknet Node 수익/업그레이드 설명 문단

유지한 용어:

- `Hacknet`
- `Hacknet Node`
- `Node`
- `hack`

## 백업과 기록

백업 파일:

- `C:\Users\user\bitburner kr\backups\main.bundle.js.before-hacknet-small-2026-06-29T03-09-32-188Z`

패치 기록:

- `C:\Users\user\bitburner kr\patches\hacknet_nodes_intro_small.json`

## 관찰한 화면 상태

스크린샷 기준으로 다음이 확인됐다.

- 제목 `Hacknet Nodes`는 유지됨
- 본문 한국어가 깨지지 않음
- 줄바꿈이 화면 폭에 맞게 자연스럽게 동작함
- 문장 중 고유명사와 한국어가 같이 있어도 큰 시각적 문제 없음
- 기능 UI, 드롭다운, 탭 영역에는 영향 없음

## 배운 점

### 1. 작은 화면 단위가 맞다

전체 번역보다 한 화면의 독립된 설명문을 먼저 바꾸는 방식이 안전하다. 문제가 생겨도 원인 범위가 좁고, 롤백도 쉽다.

### 2. 고유명사 유지 전략이 효과적이다

`Hacknet Node` 같은 명칭을 번역하지 않으니 내부 데이터/스크립트/API와 충돌할 가능성이 낮다. 사용자가 게임 내 영어 명칭을 그대로 검색하거나 스크립트에 사용할 때도 혼란이 적다.

### 3. 번들 치환은 초기 실험에 충분하다

소스 빌드 없이도 작은 패치 검증이 가능하다. 다만 패치 수가 늘어나면 수동 치환은 위험하므로 자동 패처가 필요하다.

### 4. 폰트는 다음 별도 실험으로 분리한다

현재 한글 표시는 성공했지만, 네오둥근모 적용은 별도의 통제 실험으로 진행해야 한다. 폰트 변경은 전체 UI 폭/줄높이/에디터 입력에 영향을 줄 수 있으므로 번역 치환과 분리한다.

## 다음 액션

1. 수동 치환을 자동화하는 `apply-patch.ps1` 작성
2. `revert-patch.ps1` 작성
3. 폰트만 적용하는 독립 실험 진행
4. 두 번째 번역 대상은 `Augmentation` 효과 라벨로 제한
