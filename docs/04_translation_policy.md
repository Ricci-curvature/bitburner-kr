# 번역 정책

## 핵심 원칙

1. 게임 고유명사와 API 계약은 보존한다.
2. 플레이어가 읽는 설명문과 안내문을 우선 번역한다.
3. 기능을 바꾸지 않는다.
4. 문자열 하나를 바꾼 뒤 화면에서 sanity check를 한다.
5. 애매하면 번역하지 않는다.

## 용어 기준 초안

| 원문 | 번역 | 비고 |
| --- | --- | --- |
| Effects | 효과 | 라벨 |
| hacking skill | 해킹 스킬 | 스탯 표시 |
| hacking exp | 해킹 경험치 | 스탯 표시 |
| strength skill | 힘 스킬 | 필요 시 조정 |
| defense skill | 방어 스킬 | 필요 시 조정 |
| dexterity skill | 민첩 스킬 | 필요 시 조정 |
| agility skill | 기동 스킬 | 필요 시 조정 |
| charisma skill | 카리스마 스킬 | 필요 시 조정 |
| all skills | 모든 스킬 | 효과 표시 |
| combat skills | 전투 스킬 | 효과 표시 |
| combat exp | 전투 경험치 | 효과 표시 |
| Required hacking skill | 필요 해킹 스킬 | 터미널/스탯 |
| Server security level | 서버 보안 레벨 | 터미널/스탯 |
| Chance to hack | hack() 성공 확률 | API명 유지 |
| Time to hack | hack() 소요 시간 | API명 유지 |
| Time to grow | grow() 소요 시간 | API명 유지 |
| Time to weaken | weaken() 소요 시간 | API명 유지 |

## 유지할 표기

- `Hacknet`
- `Hacknet Node`
- `Augmentation`
- `Faction`
- `BitNode`
- `Netscript`
- `Terminal`
- `Script Editor`
- `hack()` / `grow()` / `weaken()` / `scp()` / `backdoor()`
- 프로그램명과 파일명
- 서버명과 faction명

## 문체

- UI 라벨은 짧게 쓴다.
- 설명문은 반말이 아닌 간결한 해설체로 쓴다.
- 고유명사를 과하게 풀어 번역하지 않는다.
- 긴 문장은 영어 원문보다 길어질 수 있으므로 줄바꿈을 확인한다.

## 예시

원문:

> The Hacknet is a global, decentralized network of machines.

번역 후보:

> Hacknet은 전 세계에 분산된 탈중앙 기계 네트워크입니다.

원문:

> +8.00% hacking skill

번역 후보:

> +8.00% 해킹 스킬

원문:

> Chance to hack:

번역 후보:

> hack() 성공 확률:
