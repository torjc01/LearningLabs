import React, { Component } from 'react'; 
import Web3 from 'web3';
import { kryptoprovider } from '../../config.js';
import { kryptocontract } from '../../contracts/BJCToken.js';  

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host));
class Tokens extends Component{

    constructor(props){
        super(props); 
        this.state = {
            coinbase : '', 
            saldoEth : 0,
            saldoToken : 0,
        } 
    }

    async componentDidMount(){
        const transacao_hash = this.props.match.params.transacaoHash; 
        console.log(transacao_hash);

        this.loadBlockchainData();
    }

    async loadBlockchainData(){
        //    Teste de carga de contrato
        //    console.log("ABI: ", kryptocontract.abi);
        //    console.log("token", kryptocontract.tokenAddress);

       //     recupera o saldo em ethereum
       const coinbase_no = await web3.eth.getCoinbase();
       var saldoEth = await web3.eth.getBalance(coinbase_no);
        //    console.log('saldo: ', saldoEth)

       //     recurera o saldo do token
       var contract = new web3.eth.Contract(kryptocontract.abi, kryptocontract.tokenAddress); 
       var saldoBJCToken = await contract.methods.balanceOf(kryptocontract.coinbase).call(); 
        //    console.log("Saldo: " + saldoBJCToken + " BJCTokens"); 

       this.setState({
           coinbase : kryptocontract.coinbase, 
           saldoEth : saldoEth,
           saldoToken : saldoBJCToken
       });

       console.log(this.state.coinbase);
    }

    render(){
        return(
            <div>
                <h3>Tokens</h3>
                <p>
                    Coinbase : {this.state.coinbase}
                </p>
                <p>
                    Saldo ethereum : {this.state.saldoEth / 1000000000000000000} ETHs
                </p>
                <p>
                    Saldo em carteira: {this.state.saldoToken} BJCTKs
                </p>
            </div>
        );
    }
} export default Tokens; 