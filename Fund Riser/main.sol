// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundRiser{
    mapping (address=>uint) public contributors;
    address public manager;
    string reqName;
    uint public minContrib;
    uint public target;
    uint public totalAmount;
    uint public totalContributors;
    uint public deadline;

    constructor(string memory _reqName ,uint _target, uint _deadline) {
        reqName = _reqName;
        target= _target;
        deadline = block.timestamp + _deadline;
        minContrib = 100 wei;
        manager = msg.sender;
    }


    function sendEth() public payable {
        require(block.timestamp < deadline, "Petition doesn't exist anymore");
        require(msg.value >= minContrib, "100 wei is the minimum donation amount");

        if (contributors[msg.sender] == 0){
            totalContributors++;
        }
        contributors[msg.sender]+=msg.value;
        totalAmount+=msg.value;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getRefund() public {
        require(block.timestamp > deadline && totalAmount < target, "Refund is not possible right now");
        require(contributors[msg.sender] > 0);
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;    
    }

    modifier onlyManager{
        require(msg.sender == manager, "Only admin can access this");
         _;
    }

    function getAmount() public onlyManager{
        require(totalAmount >= target, "Target amount didn't reach" );
        address payable managerAddress = payable(manager);
        managerAddress.transfer(address(this).balance);
    }
}