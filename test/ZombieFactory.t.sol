// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ZombieFactory} from "../src/ZombieFactory.sol";

contract ZombieFactoryTest is Test {
    ZombieFactory factory;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        factory = new ZombieFactory();
    }

    // 01. Создание: id, имя, владелец, время, счётчики
    function testAliceCreatesZombie() public {
        vm.prank(alice);
        uint256 id = factory.createZombie("Alice");

        (string memory name,, uint256 createdAt) = factory.getZombie(id);
        assertEq(id, 0);
        assertEq(name, "Alice");
        assertEq(createdAt, block.timestamp);
        assertEq(factory.zombieToOwner(id), alice);
        assertEq(factory.ownerZombieCount(alice), 1);
        assertEq(factory.totalZombies(), 1);
    }

    // 02. Два разных адреса получают разные id
    function testTwoUsersCreateZombies() public {
        vm.prank(alice);
        uint256 idA = factory.createZombie("Alice");
        vm.prank(bob);
        uint256 idB = factory.createZombie("Bob");

        assertEq(idA, 0);
        assertEq(idB, 1);
        assertEq(factory.zombieToOwner(idB), bob);
    }

    // 03. Пустое имя
    function testEmptyNameReverts() public {
        vm.prank(alice);
        vm.expectRevert(bytes("Empty name"));
        factory.createZombie("");
    }

    // 04. Второй зомби у того же владельца
    function testSecondZombieReverts() public {
        vm.startPrank(alice);
        factory.createZombie("Alice");
        vm.expectRevert(bytes("Already has zombie"));
        factory.createZombie("Alice2");
        vm.stopPrank();
    }

    // 05. ДНК меньше DNA_MODULUS
    function testDnaIsInRange() public {
        vm.prank(alice);
        uint256 id = factory.createZombie("Alice");

        (, uint256 dna,) = factory.getZombie(id);
        assertLt(dna, factory.DNA_MODULUS());
    }
}
