// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EtherWallet { 

    //contract balance
    mapping(address => uint) user_balance;
    
    //count receive transaction
    mapping(address => uint) transaction_count;


    //deposit event
    event Deposit (
        address indexed contract_address, 
        uint value
    );

    //withdraw from contract event
    event Withdraw (
        address indexed to,
        uint value
    );

    //send ether to another waller P2P or from contract event
    event Send_Ether_To_Another_Wallet(
        address indexed from,
        address indexed to,
        uint value
    );
    

    //deposit ether to contract function
    function deposit_Ether_To_Wallet() Check_Account_Balance external payable{
        user_balance[msg.sender] += msg.value;
        emit Deposit(msg.sender,msg.value);
    }

    //withdraw from contract function
    function withdraw_Ether_From_Wallet(uint amount) Check_Wallet_Balance(amount) external {
        payable(msg.sender).transfer(amount); 
        user_balance[msg.sender]-= amount;
        emit Withdraw(msg.sender,amount);
    }

    //send ether from contract to another wallet function
    function send_Ether_From_Wallet_To_Different_Address(
        address payable to,
        uint amount
        ) Check_Wallet_Balance(amount) external payable {
        to.transfer(amount);
        user_balance[msg.sender] -= amount;
        emit Send_Ether_To_Another_Wallet(msg.sender,to,amount);
        }

    //send ether directly to another wallet function
    function send_Ether_P2P(address payable to) Check_Account_Balance external payable { 
        to.transfer(msg.value);
        emit Send_Ether_To_Another_Wallet(msg.sender,to,msg.value);
    }

    //shows contract balance function
    function show_Balance() external view returns(uint) { 
        return(user_balance[msg.sender]);
    }

    //shown number of receive transactions function
    function show_Transaction_Count() external view returns(uint) {
        return(transaction_count[msg.sender]);
    }

    
    //Checks contract balance before withdraw or send ether to another wallet from contract modifier
    modifier Check_Wallet_Balance(uint amount) { 
        require(amount <= user_balance[msg.sender] && amount !=0);
        _;
    }
    
    //checks account balance and checks that the msg.value not eqauls to 0 modifier
    modifier Check_Account_Balance() { 
        require(msg.value != 0 && msg.value <= address(this).balance);
        _;
    }


    //increases the transaction_count value by 1 after receives ether 
    receive () external payable {
        transaction_count[msg.sender]++;
    }

   
}