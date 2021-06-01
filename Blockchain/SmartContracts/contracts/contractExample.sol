pragma solidity ^0.4.21; // 

// Everything related to the token goes inside the contract. A contract is a 
// collection of functions and state (code and data) sitting at an address on 
// the ethereum blockchain.
contract yourToken{
	// the keyword public makes those variables readable from outside 
	address public minter; 
	
	// Events allow light clients (UI) to react on changes efficiently 
	mapping (address => uint) public balances; 
	
	// This is the constructor whose code is run only when the contract is created 
	event Sent(address from, address to, uint amount); 
	
	// Token constructor. Your ethereum address as minter of the contract. 
	function yourToken() public{
		minter = msg.sender;		
 	}

	// Minting function. It lets you mint any amount of coins you want to. 
	function mint(address receiver, uint amount) public{
		if(msg.sender != minter) return; 
		balances[receiver] += amount;
	}
	
	// Send token function
	function send(address receiver, uint amount) public {
		if(balances[msg.sender] < amount) return; 
		
		balances[msg.sender] 	-= amount;
		balances[receiver] 		+= amount;
		
		emit Sent(msg.sender, receiver, amount); 
	}
}
