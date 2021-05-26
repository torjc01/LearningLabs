import React, { Component } from 'react'; 
import { Link } from 'react-router-dom'; 
import Web3 from 'web3'; 
import _ from 'lodash'; 
import { kryptoprovider } from '../../config.js';
import * as ticker from '../../scripts/ticker';

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host)); 
class Contas extends Component {

    /**
     * 
     * @param {*} props 
     */
    constructor(props){
        super(props); 
        this.state = {
            accounts: [],
            saldos: [], 
            coinbase: '', 
            cotacao: {}
        }

    }

    async componentDidMount(){
        this.loadBlockchainData()
        this.getAccounts()
        this.getCotacao();
    }

    async loadBlockchainData(){
        var _coinbase = await web3.eth.getCoinbase();

        this.setState({
            coinbase : _coinbase
        });
    }

    async getCotacao(){
        let cotacao = await ticker.checkTicker('ethcad');
        this.setState({
            cotacao : cotacao
        });
    }
    async getAccounts(){
        const _accounts = this.state.accounts.slice(); 
        const _saldos = this.state.saldos.slice();
        for(var i = 0; i < 10; i++){
            var conta = await this.leituraContas(i); 
            console.log("conta========> ", conta);
            var saldo = await web3.eth.getBalance(conta); 
            // console.log("saldo ", saldo, " conta " , conta);
            _accounts.push(conta);
            _saldos.push(saldo);
        }
        this.setState({
            accounts : _accounts,
            saldos   : _saldos
        });
    }

    /**
     * TODO: mover la leitura de web3.eth.getAccounts para ser feita uma unica vez. 
     * Fazer a escrita do loop é a boa maneira de executar. Corrigir em conjunto com 
     * o metodo getAccounts().
     * @param {*} conta_idx 
     */
    async leituraContas(conta_idx){
        var conta;
        await web3.eth.getAccounts().then(function(s){conta = s[conta_idx]});
        return conta;
    }

    render(){
        console.log("cotacao: ", this.state.cotacao);
        var divFactor = 1000000000000000000;
        var tableRows = [];
        _.each(this.state.accounts, (value, index) => {
          tableRows.push(
            <tr key={this.state.accounts[index]}>
                <td className="tdCenter">{index}</td>
                <td><Link to={`/conta/${this.state.accounts[index]}`}><code>{this.state.accounts[index]}</code></Link></td>
                <td className="tdRight">{this.state.saldos[index] / divFactor}</td>
                <td className="tdRight">${((this.state.saldos[index] / divFactor) * this.state.cotacao.ask)}</td>
            </tr>
          )
        });
        return (
            <div>
                <h3>Contas</h3>
                <div>
                    Coinbase: <code>{this.state.coinbase}</code><br/>
                </div>
                <div>
                <p></p>
                <table>
                  <thead><tr>
                    <th>#</th>
                    <th>Conta No</th>
                    <th>Saldo Ether</th>
                    <th>Saldo CAD (source:{this.state.cotacao.exchange})</th>
                    
                  </tr></thead>
                  <tbody>
                    {tableRows}
                  </tbody>
                </table>
                </div>
            </div>
        ); 
    }
}export default Contas; 