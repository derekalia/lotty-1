pragma solidity ^0.4.21;

contract Lottery {
 address[] public players;
 bool public preImgTime = false;
 bool public revealTime = false;
 bool public player1Lied = false;
 bool public player2Lied = false;
  uint8 bothPlayersIn = 0;
 mapping(address => uint) addressToPreImg;
 mapping(address => uint) addressToRevealValue;



//TODO
function getPreImgTime() public view returns (bool){
  return preImgTime;
}

 //any function that accepts money needs to be marked as payable
 function enter() public payable {
    require(msg.value > .01 ether);
    require(!(players.length >= 2));
        
    bytes32 test = keccak256(5);  
    
    
    players.push(msg.sender);
    if(players.length == 2) {
      preImgTime = true;
      //call run startLottery function
      //send req to send pre img
    }
    /* TODO: BLOCKTIMES */
 }

 function commit(uint preImg) public restricted {
   //mapping to be set on the address
  addressToPreImg[msg.sender] = preImg;
   bothPlayersIn++;
  //check if both address are in and then run set revealTime = true
   if(bothPlayersIn == 2){
     revealTime = true;
     bothPlayersIn = 0;
   }
 }

 function reveal(uint val) public restricted {
   addressToRevealValue[msg.sender] = val;
   bothPlayersIn++;
   //check if both address are in and then run set revealTime = true
   if(bothPlayersIn == 2){
     checkReveal();
   }
 }


 function checkReveal() private {
   //takes in a value an
   address player1 = players[0];
   address player2 = players[1];
   //check the validity

   uint player1Check = uint(keccak256(addressToRevealValue[player1]));
   uint player2Check = uint(keccak256(addressToRevealValue[player2]));

   //check player 1
   if(player1Check==addressToPreImg[player1]){
     player1Lied = true;
   }

   //check player 2
   if(player2Check==addressToPreImg[player2]){
     player2Lied = true;
   }

   if(player2Lied == false && player1Lied == false){
     return pickWinner();
   }
 }


 function pickWinner() private {
     uint index = random() % players.length;
     players[index].transfer(this.balance);
     players = new address[](0);
     //send winner money
 }

 function random() private view returns (uint) {
     //get both preImgs and keccak256 them together
     return uint(keccak256(addressToPreImg[players[0]] + addressToPreImg[players[1]]));
 }

 modifier restricted() {
     require(msg.sender == players[0] || msg.sender == players[1]);
     _;
 }

  function getPlayers() public view returns (address[]){
    return players;
  }
}
