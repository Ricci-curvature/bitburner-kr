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
- 폰트 파일: `assets\fonts\neodgm.ttf`

## 문서

- `docs/01_research_notes.md`: 조사한 사실과 근거
- `docs/02_patch_direction.md`: 패치 방향과 금지 구역
- `docs/03_roadmap.md`: 단계별 로드맵
- `docs/04_translation_policy.md`: 번역 정책과 용어 기준

## 첫 실험 후보

1. 폰트 적용: JetBrainsMono fallback 앞에 NeoDunggeunmo/Neodgm 계열을 추가한다.
2. Hacknet Nodes 설명문 일부 번역.
3. Augmentation 효과 라벨 번역: `Effects`, `hacking skill`, `hacking exp` 등.
4. Terminal `analyze` 스탯 라벨 일부 번역.
