// SPDX-License-Identifier:- GPL-3.0

// Version from 0.8.4 to 0.9.0
pragma solidity ^0.8.4;

contract Coin {
    // The keyword "public" makes variable
    // accessible from other contracts
    address public minter;
    mapping(address => uint) public balances;

    // Event allow clients to react to specific
    // Contract changes you declare
    event Send(address from, address to, uint amount);

    // Contructor code only run when the smart contract is created
    constructor() {
        minter = msg.sender;
    }

    // Send an amount to newly created conins to an address
    // Can only be called by the contract creator
    function mint(address reciever, uint amount) public {
        require(msg.sender == minter);
        balances[reciever] += amount;
    }

    // Error allows you to provide information
    // Why an operation failed, They are returned
    // To the caller of the function
    error InsufficinetBalance(uint requested, uint available);

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address reciever, uint amount) public {
        if (amount > balances[msg.sender]) {
            revert InsufficinetBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit Send(msg.sender, reciever, amount);
    }
}
