# Phase 1 패처 설계

## 목표

수동 치환을 중단하고, JSON manifest 기반으로 안전하게 패치를 적용/검증/롤백한다.

패처의 기본 철학:

- 쓰기 전에 최대한 많이 실패한다.
- 예상과 다르면 아무것도 쓰지 않는다.
- 실제 적용은 명시적으로 요청할 때만 한다.
- 적용 결과는 상태 파일에 남긴다.
- 롤백 가능성을 항상 유지한다.

## 파일 구성

```text
bitburner kr/
  patches/
    manifest.json
    hacknet_nodes_intro_small.json
    patch-state.json
  scripts/
    apply-patch.ps1
    revert-patch.ps1
  backups/
```

## 패치 JSON 구조

각 패치 파일은 독립적으로 적용 가능해야 한다.

```json
{
  "patchId": "hacknet_nodes_intro_small",
  "description": "Hacknet Nodes intro description Korean patch",
  "gameVersion": "3.0.1",
  "targets": [
    {
      "path": "resources/app/dist/main.bundle.js",
      "replacements": [
        {
          "id": "hacknet_intro_01",
          "from": "English source text",
          "to": "한국어 번역문",
          "expectedCount": 1,
          "allowRemainingSource": false
        }
      ]
    }
  ]
}
```

## 필수 안전장치

### 1. expectedCount 검사

각 치환 항목은 `expectedCount`를 가진다.

- `0`이면 게임 업데이트로 구조가 바뀌었을 수 있다.
- `2` 이상이면 다른 문맥까지 건드릴 수 있다.
- 불일치하면 쓰기 전에 중단한다.

기본값은 `1`로 둔다.

### 2. dry-run 기본값

`apply-patch.ps1`은 기본적으로 파일을 쓰지 않는다.

예상 동작:

```powershell
.\scripts\apply-patch.ps1 -Patch patches\hacknet_nodes_intro_small.json
```

위 명령은 dry-run만 수행한다.

실제 적용은 다음처럼 명시한다.

```powershell
.\scripts\apply-patch.ps1 -Patch patches\hacknet_nodes_intro_small.json -Apply
```

출력해야 할 정보:

- 대상 파일
- 치환 항목 수
- 항목별 매치 수
- 예상 변경 수
- 백업 생성 예정 경로
- 적용 여부

### 3. patch-state.json 기록

적용 성공 시 `patches/patch-state.json`에 상태를 남긴다.

기록 필드:

```json
{
  "patchId": "hacknet_nodes_intro_small",
  "gameVersion": "3.0.1",
  "targetPath": "resources/app/dist/main.bundle.js",
  "targetHashBefore": "sha256...",
  "targetHashAfter": "sha256...",
  "backupPath": "C:/Users/user/bitburner kr/backups/...",
  "appliedAt": "2026-06-29T...",
  "replacementsApplied": 3
}
```

용도:

- 어떤 패치가 적용됐는지 추적
- 롤백 대상 백업 찾기
- Steam 업데이트 후 파일 변경 여부 판단
- 중복 적용 방지

### 4. 원문 재등장 검사

치환 후 검증은 두 가지를 분리한다.

- 번역문이 존재하는가
- 원문이 남아 있는가

`allowRemainingSource` 규칙:

- `false`: 원문이 남아 있으면 실패
- `true`: 같은 원문이 다른 문맥에 남아 있어도 허용

Hacknet 소개문처럼 정확히 한 문맥만 번역하는 항목은 `false`가 맞다.

## 기본 실행 흐름

1. 패치 JSON 읽기
2. 대상 파일 존재 확인
3. 게임 버전 확인 가능하면 기록
4. 대상 파일 해시 계산
5. 모든 치환 항목의 `expectedCount` 검사
6. dry-run 결과 출력
7. `-Apply`가 없으면 종료
8. 백업 생성
9. 치환 적용
10. 치환 후 해시 계산
11. 번역문 존재 검사
12. 원문 잔존 검사
13. `patch-state.json` 갱신
14. 결과 출력

## 실패 시 규칙

파일 쓰기 전 실패:

- 아무 파일도 변경하지 않는다.
- 실패 원인을 출력한다.

파일 쓰기 후 검증 실패:

- 백업에서 즉시 복구한다.
- 실패 상태를 출력한다.
- `patch-state.json`에는 성공으로 기록하지 않는다.

## 롤백 설계

`revert-patch.ps1`은 `patch-state.json`을 읽어 백업을 복구한다.

예상 명령:

```powershell
.\scripts\revert-patch.ps1 -PatchId hacknet_nodes_intro_small
```

기능:

- patchId로 최신 적용 기록 찾기
- 백업 파일 존재 확인
- 현재 대상 파일 해시 확인
- 복구 전 현재 파일을 별도 백업
- 원본 백업 복원
- patch-state 상태를 `reverted`로 갱신

## 구현 우선순위

1. 단일 파일/단일 패치 적용
2. dry-run/Apply 분리
3. expectedCount 검사
4. 백업 생성
5. patch-state 기록
6. allowRemainingSource 검사
7. revert 구현
8. 여러 patch 파일 일괄 적용
