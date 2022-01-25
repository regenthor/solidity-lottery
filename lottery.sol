pragma solidity >0.7.0 <0.9.0;

contract Lottery {

    // payable means this is adress, you could transfer money it, 
    //this allows the contract to really transfer any sort of amont to this address
    address payable[] public players;
    address payable public admin;

    // msg.sender key or address of the person that deployed contract
    // msg.sender regular address..
    // payable address = 
    constructor() {
        admin = payable(msg.sender);
    }

    // every functiong can cause gas in this case this is just a call function
    // there's a difference between a call function and other types of functions
    // any change that you make to the blockchain cost gas, this doesnt really make any  changes is free
    // thats why we declare view
    function getBalance() public view returns(uint) {
        return address(this).balance; // return contract balance
    } 

        // this is the function
    receive() external payable {
        require(msg.value == 1 ether, "Must be exactly 1 ether");

        require(msg.sender != admin, "Ooooh, admin cant play");

        players.push(payable(msg.sender));
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(admin == msg.sender , "You are not the Owner");
        require(players.length >= 3 , "Not enought players participating in the lottery");

        address payable winner;

        winner = players[random() % players.length];
        winner.transfer(getBalance());

        players = new address payable[](0);
    }
}