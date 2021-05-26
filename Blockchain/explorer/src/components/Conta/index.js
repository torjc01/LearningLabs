import React, {Component} from 'react';
import Web3 from 'web3';
import { kryptoprovider } from '../../config.js';

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host)); 
class Conta extends Component{

    constructor(props){
        super(props); 

        this.state = {
             conta : '',
             saldo: 0
        }
    };

    async componentDidMount(){
        var conta_hash = this.props.match.params.contaHash;
        
        console.log("conta : ", conta_hash);
        
        this.setState({
            conta : conta_hash
        });

        this.loadBlockchainData(conta_hash);
    }
    async loadBlockchainData(address_hash){

        var _saldo = await web3.eth.getBalance(address_hash); 
        console.log("saldo : ", _saldo);

        var pastLogs = await web3.eth.getPastLogs({
            address: this.state.conta
        })
        console.log("pastLogs:", pastLogs.toString());

        this.setState({
            saldo : _saldo
        }); 
    }

    render(){
        return(
            <div className="Home"> 
                <h3>Detalhamento da conta</h3>
                <table>
                    <tbody>
                        <tr>
                            <td>Conta : </td>
                            <td>{this.state.conta}</td>
                        </tr>
                        <tr>
                            <td>Saldo :</td>
                            <td>{this.state.saldo / 1000000000000000000} Ethers</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        );
    }


} export default Conta; 