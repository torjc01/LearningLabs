import React, {Component} from 'react'; 
import { Link } from 'react-router-dom'; 
import Web3 from 'web3';
import { kryptoprovider } from '../../config';
// import _ from 'lodash'; 

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host));
class Block extends Component {

    /**
     * Construtor do componente
     * @param {} props 
     */
    constructor(props) {
        super(props);
        this.state = {
            block: [], 
            timeblock : '',
            txs: []
        }
    }

    /**
     * Atualiza o estado do componente e de sua arvore DOM apos a carga do componente. 
     */
    async componentDidMount(){
        // get the block hash from URL arguments (defined by Router pattern)
        var block_hash = this.props.match.params.blockHash;

        this.getBlockState(block_hash);
    }

    /**
     * Recupera as informacoes do bloco na blockchain, recebendo como parametro o hash
     * da bloco. 
     * @param {*} block_hash 
     */
    async getBlockState(block_hash){
        console.log("Block hash: " + block_hash);
        // Use web3 to get the Block object
        var currBlockObj = await web3.eth.getBlock(block_hash, false);
        
        console.log(JSON.stringify(currBlockObj));
        console.log("Transacoes: ", currBlockObj.transactions);

        var dateObj = new Date(currBlockObj.timestamp * 1000); 
        var utcString = dateObj.toUTCString(); 
        console.log("======> UTC ", utcString);

        // Set the Component state
        this.setState({
          block_id: currBlockObj.number,
          block_hash: currBlockObj.hash,
          block_ts: Date(parseInt(this.state.block.timestamp, 10)).toString(),
          block_txs: parseInt(currBlockObj.transactions.slice().length, 10),
          block: currBlockObj,
          txs : currBlockObj.transactions,
          timeblock : utcString
        })
        console.log("block_txs", this.state.block_txs);
    }
    UNSAFE_componentWillReceiveProps(nextProps){
    //componentDidUpdate(nextProps){
        var block_hash_old = this.props.match.params.blockHash; 
        var block_hash_new = nextProps.match.params.blockHash; 

        // compare old and new URL parameters (block hash). 
        // if different, reload state using web3 
        if(block_hash_old !== block_hash_new)
            this.getBlockState(block_hash_new);
    }

    render(){
        const block = this.state.block;
        const difficulty = parseInt(block.difficulty, 10);
        const difficultyTotal = parseInt(block.totalDifficulty, 10);
        
        var tableRowes = []; 
        for(var i = 0; i < this.state.block_txs; i++){
            tableRowes.push(
                <tr key={i}>
                    <td>
                        <Link to={`/transacao/${this.state.txs[i]}`}>{this.state.txs[i]}</Link>
                    </td>
                </tr>
            );
        }

        return (
            <div className="Block">
                <h2>Block Info</h2>
                <div>
                    <table>
                    <tbody>
                        <tr><td className="tdLabel">Height: </td><td> {this.state.block.number} </td></tr>
                        <tr><td className="tdLabel">Timestamp: </td><td> {this.state.timeblock}, (Epoch: {this.state.block.timestamp}) </td></tr>
                        <tr><td className="tdLabel">Transactions: </td><td> {this.state.block_txs} </td></tr>
                        <tr><td className="tdLabel">Hash: </td><td> <code>{this.state.block.hash}</code> </td></tr>
                        <tr><td className="tdLabel">Parent hash:</td>
                        <td><Link to={`../block/${this.state.block.parentHash}`}> <code>{this.state.block.parentHash}</code> </Link></td></tr>
                        <tr><td className="tdLabel">Nonce: </td><td> <code>{this.state.block.nonce}</code> </td></tr>
                        <tr><td className="tdLabel">Size: </td><td> {this.state.block.size} bytes</td></tr>
                        <tr><td className="tdLabel">Difficulty: </td><td> {difficulty} </td></tr>
                        <tr><td className="tdLabel">Difficulty: </td><td> {difficultyTotal} </td></tr>
                        <tr><td className="tdLabel">Gas Limit: </td><td> {block.gasLimit} </td></tr>
                        <tr><td className="tdLabel">Gas Used: </td><td> {block.gasUsed} </td></tr>
                        <tr><td className="tdLabel">Sha3Uncles: </td><td> <code>{block.sha3Uncles}</code> </td></tr>
                        <tr><td className="tdLabel">Extra data: </td><td> {this.state.block.extraData} </td></tr>
                        <tr><td className="tdLabel">Transactions root: </td><td> <code>{block.transactionsRoot}</code> </td></tr>
                    </tbody>
                    </table>
                </div>
                <hr/>
                <div className="Transactions">
                    <h3>Transações</h3>
                    <div>
                        <p>Quantidade de transaçoes neste bloco:  {this.state.block_txs} </p>
                    </div>

                    <table>
                        <tbody>
                            {tableRowes}
                        </tbody>
                        
                    </table>

                </div>
            </div>
            
        );
    }

} export default Block; 