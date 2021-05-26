import React, {Component} from 'react'; 
import Web3 from 'web3';
import { Link } from 'react-router-dom'; 
import { kryptoprovider } from '../../config.js';

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host));

/**
 * Componente para renderizacao de uma transacao.
 */
class Transacao extends Component{

    constructor(props){
        super(props); 
        this.state = {
            transacaoCount : 0,
            transacao : {}, 
            recibo : {}
        } 
    }
    
    async componentDidMount(){
        const transacao_hash = this.props.match.params.transacaoHash; 
        console.log(transacao_hash);

        this.loadBlockchainData();
    }

    /**
     * Funcao que carrega le os dados da blockchain e carrega no estado do componente. 
     */
    async loadBlockchainData(){
        var detalhesTrans = await web3.eth.getTransaction(this.props.match.params.transacaoHash);
        console.log(detalhesTrans);

        var recibo = await web3.eth.getTransactionReceipt(this.props.match.params.transacaoHash);
        console.log("recibo", recibo);
        console.log("contrato address", recibo.contractAddress);
        
        // console.log("status", this.state.recibo.state);
        // var estado = this.validaEstado(this.state.recibo.status); 
        // console.log("estado", estado);

        const quantidadeConfirmacao = await this.getConfirmations(this.props.match.params.transacaoHash); 
        console.log('quantidade', quantidadeConfirmacao);

        this.setState({
            transacaoCount : quantidadeConfirmacao,
            transacao : detalhesTrans, 
            recibo : recibo
        });
    }

    /**
     * Funcao para determinar a quantidade de confirmacoes que uma transacao recebeu. 
     * @dev para determinar a quantidade de confirmacoes, calcular a diferença entre 
     * o numero do bloco atual e do numro do bloco da transacao. 
     * @param {*} txHash hash da transacao desejada
     */

    async getConfirmations(txHash) {
        try{
            // instancia web3 com httpProvider
            const txrx = await web3.eth.getTransaction(txHash)
            const currentBlock = await web3.eth.getBlockNumber()
            return txrx.blockNumber == null ? 0 : currentBlock - txrx.blockNumber
        } catch(error){
            console.log(error)
        }
    }

    async confirmEtherTransaction(txHash, confirmations = 10){
        setTimeout(async() => {
            const txrxConfirmations = await this.getConfirmations(txHash)
            console.log('Transaction with hash ' + txHash + ' has ' + txrxConfirmations + ' confirmations')
            if(txrxConfirmations >= confirmations){
                console.log('Transaction with hash ' + txHash + ' has been successfully confirmed.')
                return
            }
            // chamada recursiva 
            return this.confirmEtherTransaction(txHash, confirmations)
        }, 30 * 1000);
    }

    // /**
    //  * 
    //  * @param {*} status 
    //  */
    // async validaEstado(status) {
    //      if(status === true)
    //         return "Revertida" 
    //         else return "Sucesso";
    // }

    render(){
        var tableRowes = []; 
        for(var i = 0; i < 1; i++){
            tableRowes.push(
                <tbody key={i} >
                    <tr>
                        <td>Hash:</td>
                        <td><code>{this.state.transacao.hash}</code></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td>
                            <code>{
                                this.state.recibo.status ? "Sucesso" : "Falhou"
                            }</code>
                        </td>
                    </tr>
                    <tr>
                        <td>Endereço do contrato:</td>
                        <td>
                            <code>{
                                this.state.recibo.contractAddress === null ? "Nao é contrato" : this.state.recibo.contractAddress
                            }</code>
                        </td>
                    </tr>
                    <tr></tr>
                    <tr>
                        <td>Qtd de confirmacoes:</td>
                        <td>{this.state.transacaoCount}</td>
                    </tr>
                    <tr>
                        <td>nonce:</td> 
                        <td>{this.state.transacao.nonce}</td>
                    </tr>
                    <tr>
                        <td>Block hash:</td> 
                        <td><code>{this.state.transacao.blockHash}</code></td>
                    </tr>
                    <tr>
                        <td>Block number:</td> 
                        <td>{this.state.transacao.nonce}</td>
                    </tr>
                    <tr>
                        <td>Transaction index:</td> 
                        <td>{this.state.transacao.transactionIndex}</td>
                    </tr>
                    <tr>
                        <td>From:</td> 
                        <td><Link to={`/conta/${this.state.transacao.from}`}><code>{this.state.transacao.from}</code></Link></td>
                    </tr>
                    <tr>
                        <td>To:</td> 
                        <td><Link to={`/conta/${this.state.transacao.to}`}><code>{this.state.transacao.to}</code></Link></td>
                    </tr>
                    <tr>
                        <td>Value:</td> 
                        <td>{this.state.transacao.value}</td>
                    </tr>
                    <tr>
                        <td>Gas:</td> 
                        <td>{this.state.transacao.gas}</td>
                    </tr>
                    <tr>
                        <td>Gas price:</td> 
                        <td>{this.state.transacao.gasPrice}</td>
                    </tr>
                    <tr>
                        <td>Cumulative Gas used:</td> 
                        <td>{this.state.recibo.cumulativeGasUsed}</td>
                    </tr>
                    <tr>
                        <td>Value:</td> 
                        <td>{this.state.transacao.value}</td>
                    </tr>
                    <tr>
                        <td>Input:</td> 
                        <td>
                            <textarea rows="20" cols="150" value={this.state.transacao.input}>    
                            </textarea>
                        </td>
                    </tr>
                </tbody>
            );
        }

        return(
            <div>
                <h3> Detalhes da transação </h3>
                <table>
                  <thead><tr>
                    <th>Campo</th>
                    <th>Valor</th>           
                  </tr></thead>
                    {tableRowes}
                </table>
            </div>
        );
    }
} export default Transacao;