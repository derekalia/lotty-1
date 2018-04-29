import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import web3 from './utils/web3';
import game from './utils/game';
// import web3 from 'web3';



// const web3 = new Web3 new Web3(provider);



class App extends Component {

state={account:'',revealTime:'',preImgTime:'',revealTime:'', players:'',winner:'',player2Lied:'',player1Lied:''}

  async componentDidMount() {
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });
  }


  join = async () => {
    await game.methods.enter().send({ from: this.state.account, value: 11000000000000000 });
  }

  update = async () => {
    let preImgTime =  await game.methods.getPreImgTime().call({ from: this.state.account});
    let revealTime =  await game.methods.getRevealTime().call({ from: this.state.account});
    let player1Lied =  await game.methods.getPlayer1Lied().call({ from: this.state.account});
    let player2Lied =  await game.methods.getPlayer2Lied().call({ from: this.state.account});
    let players =  await game.methods.getPlayers().call({ from: this.state.account});
    let winner = await game.methods.getWinner().call({ from: this.state.account });

    this.setState({preImgTime,revealTime,player1Lied,player2Lied,players,winner});
  }

  async renderCommitInput() {

    var hash = web3.utils.sha3(web3.utils.toHex(8), {encoding:"hex"});
    console.log(hash); // "0xed973b234cf2238052c9ac87072c71bcf33abc1bbd721018e0cca448ef79b379"

  }

  renderRevealInput() {

  }

  keccakIt(e){
    let val = e.target.value
    var hash = web3.utils.sha3(web3.utils.toHex(val), {encoding:"hex"});
    this.setState({value: val, hash})
  }

  revealUpdate(e){
    let reveal = e.target.value
    this.setState({ value: reveal });
  }

  async submitCommit(){
    await game.methods.commit(this.state.hash).send({ from: this.state.account});
  }

  async checkBothPlayersIn() {
    const bothPlayersIn = await game.methods.getBothPlayersIn().call({ from: this.state.account });
    this.setState({ bothPlayersIn });
  }

  async submitReveal() {
    const submitReveal = await game.methods.reveal(this.state.value).send({ from: this.state.account });
  }

  async sendDatMoney() {
    await game.methods.pickWinner().send({ from: this.state.account });
  }


  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to Commit & Reveal Lottery</h1>
          <h2 >Welcome {this.state.account}</h2>

        </header>
<button onClick={()=>this.update()}>update</button>
       <div onClick={this.renderCommitInput}>yo</div>

        <div onClick={this.join}>join</div>
        {this.state.preImgTime && <div><input onChange={(e)=>this.keccakIt(e)}/></div>}
        {this.state.preImgTime && this.state.value && <div>{this.state.value}</div>}
        {this.state.preImgTime && this.state.hash && <div>{this.state.hash}</div>}
        {this.state.preImgTime && <button onClick={()=>this.submitCommit()}>Submit Pre Image</button>}

      <div style={{marginTop:'30px'}}>
        {this.state.revealTime && <div><input value={this.state.value} onChange={(e)=>this.revealUpdate(e)}/></div>}
        {this.state.revealTime && <button onClick={()=>this.submitReveal()}>Submit Reveal</button>}
          <div>winner</div>
        {this.state.revealTime && this.state.preImgTime && this.state.winner}
      </div>

      <button onClick={()=>this.sendDatMoney()}>Send Dat Money</button>



      </div>
    );
  }
}

export default App;
