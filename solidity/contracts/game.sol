pragma solidity ^0.4.21;

contract Lottery {
 address[] public players;
 bool public preImgTime = false;
 bool public revealTime = false;
 bool public player1Lied = false;
 bool public player2Lied = false;
 uint8 bothPlayersIn = 0;
 mapping(address => bytes32) addressToPreImg;
 mapping(address => uint) addressToRevealValue;
 address winner = 0x000;
 bool public here = false;
 uint public randomNumber = 0;



 //any function that accepts money needs to be marked as payable
 function enter() public payable {
    require(msg.value > .01 ether);
    require(!(players.length >= 2));

    players.push(msg.sender);
    if(players.length == 2) {
      preImgTime = true;
      //call run startLottery function
      //send req to send pre img
    }
    /* TODO: BLOCKTIMES */
 }

 function commit(bytes32 preImg) public playerRestricted {
   //mapping to be set on the address
  addressToPreImg[msg.sender] = preImg;
   bothPlayersIn++;
  //check if both address are in and then run set revealTime = true
   if(bothPlayersIn == 2){
     revealTime = true;
     bothPlayersIn = 0;
   }
 }

 function reveal(uint val) public playerRestricted {
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

   bytes32 player1Check = keccak256(addressToRevealValue[player1]);
   bytes32 player2Check = keccak256(addressToRevealValue[player2]);

   //check player 1
   if(player1Check==addressToPreImg[player1]){
     player1Lied = true;
   }

   //check player 2
   if(player2Check==addressToPreImg[player2]){
     player2Lied = true;
   }

   if(player2Lied == false && player1Lied == false){
       randomNumber = random();
      pickWinner();
   }
 }

 /* TODO: check for blocktimes in modifier moneys go to user who sent, send both back if nobody sent*/

 /* TODO:and send money in case of cheating */

 function pickWinner() private {

   uint index = randomNumber % players.length;
     players[index].transfer(this.balance);
    //  players = new address[](0);
     //send winner money
     winner = players[index];
 }

 function random() private view returns (uint) {
     //get both preImgs and keccak256 them together
     return uint(keccak256(addressToPreImg[players[0]], addressToPreImg[players[1]]));
 }

 modifier playerRestricted() {
     require(msg.sender == players[0] || msg.sender == players[1]);
     _;
 }

 //Getters
 function getPreImgTime() public view returns (bool){
   return preImgTime;
 }

 function getRevealTime() public view returns (bool){
   return revealTime;
 }

 function getPlayer1Lied() public view returns (bool){
   return player1Lied;
 }

 function getPlayer2Lied() public view returns (bool){
   return player2Lied;
 }

 function getbothPlayersIn() public view returns (uint){
   return bothPlayersIn;
 }

 function getPlayers() public view returns (address[]){
   return players;
 }
  function getWinner() public view returns (address){
   return winner;
 }

}
