// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

/*
所有人都可以存钱
    ETH
只有合约 owner 才可以取钱
只要取钱，合约就销毁掉 selfdestruct
扩展：支持主币以外的资产
    ERC20
    ERC721
*/
contract Bank {
    //状态变量，用于存储合约所有者的地址
    //immutable变量在部署时赋值后不可能更改
    address public immutable owner;
    //事件
    //用于记录存款操作，包含存款地址和金额
    event Deposit(address _ads, uint256 amount);
    //用于记录取款操作，包含取款金额
    event Withdraw(uint256 amount);

    //receive函数，用于接受以太坊转账时自动调用
    //转账
    receive() external payable {
      //触发Deposit事件，记录存款地址和金额
        emit Deposit(msg.sender, msg.value);
    }

    //构造函数，在合约部署时执行，设置合约所有者并接收初始资金
    constructor() payable {
        owner = msg.sender;
    }

    //方法

    //取钱
    function  Withdraw() external {
      //检查调用者是否是合约者
      require(msg.sender == owner,"Not Owner");
      //触发Withdraw事件，记录取款金额，获得当前以太币余额
      emit Withdraw(address(this).balance);
      //销毁合约并将剩余资金转移给所有者
      selfdestruct(payable(msg.sender))
    }
    function getBalance() external view returns (uint256){
      return address(this).balance;
    }
}
