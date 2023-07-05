// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTrick {
    // gatekeeperthreeを継承
    GatekeeperThree public target;
    address public trick;
    // block の時間がpwd
    uint256 private password = block.timestamp;

    constructor(address payable _target) {
        // GatekeeperThree targetはGatekeeperThree(_target)
        target = GatekeeperThree(_target);
    }

    function checkPassword(uint256 _password) public returns (bool) {
        // 時間が正しければ？
        if (_password == password) {
            return true;
        }
        // 上と違う時間なのかな？？
        password = block.timestamp;
        return false;
    }

    function trickInit() public {
        // trickは現在のコントラクトアドレス
        trick = address(this);
    }

    function trickyTrick() public {
        // address(this)が送信者で、？？？？？どゆこと
        if (address(this) == msg.sender && address(this) != trick) {
            // gatekeeperthreeはallowentranceがtrueになる。passwordは？
            target.getAllowance(password);
        }
    }
}

contract GatekeeperThree {
    address public owner;
    address public entrant;
    bool public allowEntrance;

    // create Trickで使う
    SimpleTrick public trick;

// これは変更可能、ヒントかな
    function construct0r() public {
        owner = msg.sender;
    }

    modifier gateOne() {
        // msg.sender!=tx.originと同じ
        require(msg.sender == owner,"1-1");
        require(tx.origin != owner,"1-2");
        _;
    }

    modifier gateTwo() {
        // pwdが分かればいい
        require(allowEntrance == true,"2");
        _;
    }

    modifier gateThree() {
        // どうやってbalance増やす？後半なに?
        if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
            _;
        }
    }

// checkpwdで時間チェック
    function getAllowance(uint256 _password) public {
        if (trick.checkPassword(_password)) {
            allowEntrance = true;
        }
    }

    function createTrick() public {
        // 新しいsimpletrick!
        trick = new SimpleTrick(payable(address(this)));
        // 同じ名前の変数？？initしてaddress(this)
        trick.trickInit();
    }

    function enter() public gateOne gateTwo gateThree {
        // transactionの送信者＝自分
        entrant = tx.origin;
    }

// これなに？？
    receive() external payable {}
}
