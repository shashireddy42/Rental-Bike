// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Bike{
    address owner;
    constructor(){  
        owner=msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    //Renter details
    struct Renter{
        address payable renteraddress;
        string name;
        uint id;
        uint age;
        uint balance;
        uint256 due;
        bool active;
        uint pickup;
        uint drop;
    }

    uint counter;
   Renter[]public renters;
   //Renters register 
   function addrenter(address payable _address,string memory _name, uint _age ) public {
       require(_age>=18,"Your not eligble");
       require(_address!=msg.sender,"Owner address can not be renter address");
       require(_address != address(0), "Not valid address");
       Renter memory temp;
       temp.renteraddress=_address;
       temp.name=_name;
       temp.age=_age;
       temp.id=counter++;
       renters.push(temp);
   }
   //Pickup the bike
  function checkin(uint id)public{
      renters[id-1].active=true;
      renters[id-1].pickup=block.timestamp;
      //due(id);
  }
  //Drop
  function checkout(uint id) public {
      renters[id-1].active=false;
      renters[id-1].drop=block.timestamp;
  }
  function timespan(uint pickup, uint drop) internal pure returns(uint){
      return drop-pickup;
  }
  //Time calculation 
  function Duration(uint id)public  view returns(uint){
      uint time=timespan(renters[id-1].pickup,renters[id-1].drop);
      uint timeinminutes=time/60;
      return timeinminutes;
  }
  //Balance of contract
  function balance()public view returns(uint){
      return address(this).balance;
  }
  //Balance of contract
  function balanceof(uint id)public view returns(uint){
     return renters[id-1].balance;
  }
  //Time spent on ride
  function due(uint id)internal {
      uint timeinminutes=Duration(id);
      uint fiveminute=timeinminutes/5;
      renters[id-1].due= fiveminute * 1/100;

  }
  // Depoisting the balance 
   function deposit(uint id) payable public {
        renters[id-1].balance += msg.value;
    }

    //Payment
    function makePayment(uint id) payable public {
      require(renters[id-1].due > 0, "You do not have anything due at this time.");
      require(renters[id-1].renteraddress!=owner,"Owner can not make payment");
      require(renters[id-1].balance > msg.value, "You do not have enough funds to cover payment. Please make a deposit.");
      renters[id -1].balance -= msg.value;
      renters[id-1].due = 0;
      renters[id-1].pickup = 0;
      renters[id-1].drop= 0;
    }

}


