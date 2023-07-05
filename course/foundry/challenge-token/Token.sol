// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Token {
    string public name = "Token";
    uint256 public totalSupply = 10000;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        ////////// YOUR CODE HERE //////////
        if (balanceOf[msg.sender]>=amount){
            balanceOf[msg.sender] -= amount;
            balanceOf[to] += amount;
            return true;
            }
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
        ////////// YOUR CODE HERE //////////
        if (allowance[from][msg.sender] >= amount && balanceOf[from]>=amount){
            if (allowance[from][msg.sender] != type(uint256).max){
                allowance[from][msg.sender] -= amount;
            }
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
            return true;
            }
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        ////////// YOUR CODE HERE //////////
        allowance[msg.sender][spender] = amount;
        return true;
    }
}
