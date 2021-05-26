import React , {Component} from 'react';
import logo from './logoHex.png'; 
import './style.css'; 
import Block from './../Block'; 
import Home from './../Home'; 
import Contas from './../Contas';
import Conta from './../Conta';
import Transacao from './../Transacao';
import Tokens from './../Tokens';
import {BrowserRouter as Router, Route, Link} from 'react-router-dom';

class App extends Component{

    render(){
        return(
            <div className="App">
                <div className="App-header">
                    <table>
                        <tbody>
                            <tr>
                                <td>
                                    <img src={logo} className="App-logo" alt="logo" width="100" height="100"/>
                                </td>
                                <td>
                                <h2>Kryptogarten Block Explorer</h2>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div className="App-Nav"> 
                    <Router>
                        <div>
                            <Link to="/">Home</Link> &nbsp;
                            <Link to="/contas">Contas</Link> &nbsp;
                            <Link to="/block">Block</Link> &nbsp; 
                            <Link to="/conta">Conta</Link> &nbsp;
                            <Link to="/transacao">Transação</Link>&nbsp;
                            <Link to="/tokens">Tokens</Link>
                            
                            <Route exact path="/" component={Home} />
                            <Route exact path="/block" render={() => (
                                <h3>Selecione um blockhash por favor.</h3>
                            )}/>
                            <Route path="/block/:blockHash" component={Block}/>
                            <Route exact path="/contas" component={Contas}/>
                            <Route exact path="/conta" render={() => (
                                <h3>Selecione uma conta por favor.</h3>
                            )}/>
                            <Route path="/conta/:contaHash" component={Conta}/>
                            <Route exact path="/transacao" render={() => (
                                <h3>Selecione uma transação por favor</h3>
                            )}/>
                            <Route path="/transacao/:transacaoHash" component={Transacao}/>

                            <Route exact path="/tokens" component={Tokens}/>

                        </div>
                    </Router>
                </div>
            </div>
        ); 
    }
} export default App;