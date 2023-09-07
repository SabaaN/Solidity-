// SPDX-License-Identifier: MIT License

pragma solidity ^0.8.20;

contract EventOrganization{
    struct Event{
        address admin;
        string name;
        uint price;
        uint date;
        uint ticket;
        uint budget;
        uint ticketRemain;

    }

    mapping(uint => Event) public events;
    mapping(address =>mapping(uint=>uint)) public tickets;
    uint public nextID;

    function createEvent(string memory name, uint price, uint date, uint budget, uint ticket) external {
        require(date>block.timestamp, "You cannot create events for past dates");
        require(ticket>0 , "Your event should have more than 0 tickets");
        require(budget>100 , "Our minimum budget requirement is 100 dollars");
        events[nextID] = Event(msg.sender, name, date, price, budget, ticket, ticket);
        nextID++;
    }

    function buyTicket(uint id,uint quantity) external payable{
       require(events[id].date!=0,"Event does not exist");
       require(events[id].date>block.timestamp,"Event has already occured");
       Event storage _event = events[id];
       require(msg.value==(_event.price*quantity),"Insufficient Ether");
       require(_event.ticketRemain>=quantity,"SOLD OUT!!");
       _event.ticketRemain-=quantity;
       tickets[msg.sender][id]+=quantity;
    }

}
