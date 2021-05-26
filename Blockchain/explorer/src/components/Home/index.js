import React, {Component} from 'react'; 
import Web3 from 'web3';
import _ from 'lodash'; 
import {Link} from 'react-router-dom';
import { kryptoprovider } from '../../config.js';  

var web3 = new Web3(new Web3.providers.HttpProvider(kryptoprovider.host)); 
class Home extends Component {

    /**
     * 
     * @param {*} props 
     */
    constructor(props){
        super(props);
        this.state = {
          block_ids   : [],
          block_hashes: [],
          curr_block  : null, 
          coinbase    : null, 
          saldo       : 0
        }
    }

    /**
     * 
     */
    async componentDidMount() {
        console.log(kryptoprovider.host);
        this.loadBlockchainData()
    }
    
    /**
     * 
     */
    async loadBlockchainData(){
      const curr_block_no = await web3.eth.getBlockNumber()
      const coinbase_no = await web3.eth.getCoinbase();
      var saldo = await web3.eth.getBalance(coinbase_no);
      console.log('saldo: ', saldo)
      
      this.setState({
        saldo : saldo,
        curr_block: curr_block_no, 
        coinbase : coinbase_no
      });
      //console.log("loadBlockData", curr_block_no);
      this.getBlocks(curr_block_no);
    }

    /**
     * 
     * @param {*} curr_block_no 
     */
    async getBlocks(curr_block_no){

      var max_blocks = kryptoprovider.qtdMaxBlocks; 

      //console.log("current,", curr_block_no)
      const _block_ids = this.state.block_ids.slice();
      const _block_hashes = this.state.block_hashes.slice(); 
      
      if(curr_block_no < max_blocks) max_blocks = curr_block_no;
      //console.log("curr_block_no", curr_block_no); 
      //console.log("max_blocks", max_blocks);
      for(var i = 0; i < max_blocks; i++, curr_block_no--){
        var curBlockObj = await web3.eth.getBlock(curr_block_no);
        _block_ids.push(curBlockObj.number);
        _block_hashes.push(curBlockObj.hash); 
      }
      this.setState({
        block_ids     : _block_ids, 
        block_hashes  : _block_hashes
      });
    }

    /**
     * 
     * @param {*} nextProps 
     */
    async componentDidUpdate(nextProps) {
      var block_hash_old = this.props.match.params.blockHash;
      var block_hash_new = nextProps.match.params.blockHash;
      // compare old and new URL parameter (block hash)
      // if different, reload state using web3
      if (block_hash_old !== block_hash_new)
      this.getBlockState(block_hash_new);
    }

    /**
     * 
     */
    render(){
        var tableRows = [];
        _.each(this.state.block_ids, (value, index) => {
          tableRows.push(
            <tr key={this.state.block_hashes[index]}>
              <td className="tdCenter">{this.state.block_ids[index]}</td>
              <td><Link to={`/block/${this.state.block_hashes[index]}`}><code>{this.state.block_hashes[index]}</code></Link></td>
            </tr>
          )
        });
        return(
            <div className="Home">
                <h2>Ultimos blocos </h2> 
                <table>
                  <tbody>
                    <tr>
                      <td>Current block:</td>
                      <td>{this.state.curr_block}</td>
                    </tr>
                    <tr>
                      <td>Coinbase:</td>
                      <td>{this.state.coinbase}</td>
                    </tr>
                    <tr>
                      <td>Saldo da coinbase:</td>
                      <td>{this.state.saldo / 1000000000000000000}</td>
                    </tr>
                  </tbody>
                </table>
                <br/>
                <table>
                  <thead><tr>
                    <th>Block No</th>
                    <th>Hash</th>
                  </tr></thead>
                  <tbody>
                    {tableRows}
                  </tbody>
                </table>
            </div>
        );
    }

} export default Home; 