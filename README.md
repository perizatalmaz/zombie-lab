# Алмаз кызы Перизат 2461

# Zombie Factory (Фабрика криптозомби)

Практическая работа — смарт-контракт `ZombieFactory` на Solidity `^0.8.20`, тесты на Foundry (Forge).

Каждый пользователь может создать одного зомби с именем. Зомби получает id, ДНК и время создания. Данные и владельцы хранятся в контракте, о создании сообщает событие `ZombieCreated`.

## Методы

| Метод | Назначение |
|:--|:--|
| `createZombie(name)` | создать зомби |
| `totalZombies()` | количество зомби |
| `getZombie(id)` | имя, ДНК и время создания зомби |

## Запуск

```
forge build
forge test -vv
```

## Результат тестов

Ran 5 tests for test/ZombieFactory.t.sol:ZombieFactoryTest
[PASS] testAliceCreatesZombie() (gas: 213586)
[PASS] testDnaIsInRange() (gas: 188916)
[PASS] testEmptyNameReverts() (gas: 33723)
[PASS] testSecondZombieReverts() (gas: 198885)
[PASS] testTwoUsersCreateZombies() (gas: 324297)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 1.43ms (1.64ms CPU time)

## Почему вычисление ДНК не является безопасной случайностью?

ДНК считается из известных данных — адреса пользователя и имени зомби. Функция `keccak256` детерминированная, поэтому результат можно вычислить заранее и подобрать имя под нужную ДНК. Для настоящей случайности используют Chainlink VRF или схему commit-reveal.
