// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract GatekeeperTwo {
    address public entrant;
// keeper1と同じ：なにに使う？？
    modifier gateOne() {
        require(msg.sender != tx.origin,"1");
        _;
    }
// callerのcodesizeが0=>contructorに収める：EOAを区別
    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0,"2");
        _;
    }
// msg.senderをencodeしてkeccak256ハッシュbytes20＝＞先頭bytes8=>uint64(8バイト満杯)して
// gatekeyで反転したのがuint64のmax値に等しい。gatekeyはbytes8
    modifier gateThree(bytes8 _gateKey) {
        require(uint64(
            bytes8(
                keccak256(
                abi.encodePacked(msg.sender)
                )
            )
        ) ^ uint64(_gateKey) == type(uint64).max,
        "3"
        );
        _;
    }

    // gate1,2,3がtrueならenter

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
