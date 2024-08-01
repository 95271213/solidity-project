pragma solidity ^0.8.17;

/*
 *weth合约用于包装eth主币，作为ERC20的合约。标准的ERC20合约包括如下几个功能
 *3个查询：
 *balanceOf:查询指定地址的Token数量
 *allowance:查询指定地址对另一个地址的剩余授权额度
 *totalSupply:查询当前合约的Token总量
 *2个交易：
 *transfer:从当前调用者地址发送指定数量的Token到指定地址，这是一个写入方法，所有还会抛一个Transfer事件
 *transferFrom:当向另一个合约地址存款时，对方合约必须调用transferFrom才可以把Token拿到它自己的合约中
 *2个事件
 *Transfer
 *Approval
 *1个授权
 *approve:授权指定地址可以操作调用者的最大Token数量
 */

contract WETH {
    //代币的名称
    string public name = "Wrapped Ether";
    //代币的符号
    string public symbol = "WETH";
    //代币的小数位数，通常是18
    unint8 public decimals = 18;

    //事件，用于记录授权操作
    event Approval(
        address indexed src,
        address indexed delegateAds,
        uint256 amount
    );
    //事件，用于记录转账操作
    event Transfer(address indexed src, adress indexed toAds, uint256 amount);
    //事件，用于记录存款操作
    event Deposit(address indexed toAds, uint256 amount);
    //事件，用于记录取款操作
    event Withdraw(address indexed src, uint256 amount);

    //映射，用于存储每个地址的余额
    mapping(address => uint) public balanceOf;
    //映射，用于存储每个地址对其他地址的授权额度
    mapping(adress => mapping(address => uint256)) public allowance;

    //存款函数，接受以太币和增加存款人得余额
    function deposit() public payable {
      //增加存款人得余额
      balanceOf[msg.sender] += msg.value;
      //触发存款事件
      emit Deposit(msg.sender,msg.value)
    }

    //取款函数
    function withdraw(uint256 amount) public{
      
      require(balanceOf[msg.sender] >= amount);
      //减少账户余额
      balanceOf[msg.sender] -= amount;
      //从当前调用者地址发送指定数量的 Token 到指定地址
      payable(msg.sender).transfer(amount);
      //触发取款事件
      emit Withdraw(msg.sender,amount)
    }
    //查询当前合约的Token总量
    function totalSupply() public view returns(uint256){
      return address(this).balance
    }
    //授权指定地址可以操作调用者的最大 Token 数量
    function approve(address delegateAds, uint256 amount) public returns(bool){
       allowance[msg.sender][delegateAds] = amount;
       //触发授权事件
       emit Approval(msg.sender,delegateAds,amount);
       return true
    }
     
     function transfer(address toAds,uint256 amount) public returns(bool){
        return transferFrom(msg.sender,toAds,amount)
     }
     function transferFrom(
      address src,
      address toAds,
      uint256 amount
     ) public returns(bool){
      require(balanceOf[src] >= amount);
      if(src != msg.sender){
         require(allowance[src][msg.sender] >= amount);
         allowance[src][msh.sender] -= amount;
      }
      balanceOf[src] -= amount;
      balanceOf[toAds] += amount;
      emit Transfer(src,toAds,amount);
      return true
     }

     fallback() external payable{
      deposit()
     }
     receive() external payable{
      deposit()
     }
}
