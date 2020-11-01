pragma solidity ^0.5.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

import "../interfaces/IController.sol";
import "../interfaces/dERC20.sol";
import "../interfaces/dRewards.sol";
import "../interfaces/UniswapRouter.sol";

contract StrategyDForceDAI {
    // using SafeERC20 for IERC20;
    // using Address for address;
    // using SafeMath for uint256;
    
    // address constant public want = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    // address constant public d = address(0x02285AcaafEB533e03A7306C55EC031297df9224);
    // address constant public pool = address(0xD2fA07cD6Cd4A5A96aa86BacfA6E50bB3aaDBA8B);
    // address constant public df = address(0x431ad2ff6a9C365805eBaD47Ee021148d6f7DBe0);
    // address constant public output = address(0x431ad2ff6a9C365805eBaD47Ee021148d6f7DBe0);
    // address constant public unirouter = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    // address constant public weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // used for df <> weth <> usdc route

    // address constant public yfii = address(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);

    
    // uint public strategyfee = 0;
    // uint public fee = 400;
    // uint public burnfee = 500;
    // uint public callfee = 100;
    // uint constant public max = 1000;

    // uint public withdrawalFee = 0;
    // uint constant public withdrawalMax = 10000;
    
    // address public governance;
    // address public strategyDev;
    // address public controller;
    // address public burnAddress = 0xB6af2DabCEBC7d30E440714A33E5BD45CEEd103a;

    // string public getName;

    // address[] public swap2YFIIRouting;
    // address[] public swap2TokenRouting;
    
    
    constructor() public {
        // governance = msg.sender;
        // controller = 0x8C2a19108d8F6aEC72867E9cfb1bF517601b515f;
        // getName = string(
        //     abi.encodePacked("yfii:Strategy:", 
        //         abi.encodePacked(IERC20(want).name(),"DF Token"
        //         )
        //     ));
        // swap2YFIIRouting = [output,weth,yfii];
        // swap2TokenRouting = [output,weth,want];
        // doApprove();
        // strategyDev = tx.origin;
    }

    // function doApprove () public{
    //     IERC20(output).safeApprove(unirouter, 0);
    //     IERC20(output).safeApprove(unirouter, uint(-1));
    // }
    
    
    // function deposit() public {
    //     uint _want = IERC20(want).balanceOf(address(this));
    //     if (_want > 0) {
    //         IERC20(want).safeApprove(d, 0);
    //         IERC20(want).safeApprove(d, _want);
    //         dERC20(d).mint(address(this), _want);
    //     }
        
    //     uint _d = IERC20(d).balanceOf(address(this));
    //     if (_d > 0) {
    //         IERC20(d).safeApprove(pool, 0);
    //         IERC20(d).safeApprove(pool, _d);
    //         dRewards(pool).stake(_d);
    //     }
        
    // }
    
    // // Controller only function for creating additional rewards from dust
    // function withdraw(IERC20 _asset) external returns (uint balance) {
    //     require(msg.sender == controller, "!controller");
    //     require(want != address(_asset), "want");
    //     require(d != address(_asset), "d");
    //     balance = _asset.balanceOf(address(this));
    //     _asset.safeTransfer(controller, balance);
    // }
    
    // // Withdraw partial funds, normally used with a vault withdrawal
    // function withdraw(uint _amount) external {
    //     require(msg.sender == controller, "!controller");
    //     uint _balance = IERC20(want).balanceOf(address(this));
    //     if (_balance < _amount) {
    //         _amount = _withdrawSome(_amount.sub(_balance));
    //         _amount = _amount.add(_balance);
    //     }
        
    //     uint _fee = 0;
    //     if (withdrawalFee>0){
    //         _fee = _amount.mul(withdrawalFee).div(withdrawalMax);        
    //         IERC20(want).safeTransfer(IController(controller).rewards(), _fee);
    //     }
        
        
    //     address _vault = IController(controller).vaults(address(want));
    //     require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
    //     IERC20(want).safeTransfer(_vault, _amount.sub(_fee));
    // }
    
    // // Withdraw all funds, normally used when migrating strategies
    // function withdrawAll() external returns (uint balance) {
    //     require(msg.sender == controller, "!controller");
    //     _withdrawAll();
        
        
    //     balance = IERC20(want).balanceOf(address(this));
        
    //     address _vault = IController(controller).vaults(address(want));
    //     require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
    //     IERC20(want).safeTransfer(_vault, balance);
    // }
    
    // function _withdrawAll() internal {
    //     dRewards(pool).exit();
    //     uint _d = IERC20(d).balanceOf(address(this));
    //     if (_d > 0) {
    //         dERC20(d).redeem(address(this),_d);
    //     }
    // }
    
    // function harvest() public {
    //     require(!Address.isContract(msg.sender),"!contract");
    //     dRewards(pool).getReward();
        
    //     doswap();
    //     dosplit();//分yfii
    //     deposit();
    // }

    // function doswap() internal {
    //     uint256 _2token = IERC20(output).balanceOf(address(this)).mul(90).div(100); //90%
    //     uint256 _2yfii = IERC20(output).balanceOf(address(this)).mul(10).div(100);  //10%
    //     UniswapRouter(unirouter).swapExactTokensForTokens(_2token, 0, swap2TokenRouting, address(this), now.add(1800));
    //     UniswapRouter(unirouter).swapExactTokensForTokens(_2yfii, 0, swap2YFIIRouting, address(this), now.add(1800));
    // }
    // function dosplit() internal{
    //     uint b = IERC20(yfii).balanceOf(address(this));
    //     uint _fee = b.mul(fee).div(max);
    //     uint _callfee = b.mul(callfee).div(max);
    //     uint _burnfee = b.mul(burnfee).div(max);
    //     IERC20(yfii).safeTransfer(IController(controller).rewards(), _fee); //4%  3% team +1% insurance
    //     IERC20(yfii).safeTransfer(msg.sender, _callfee); //call fee 1%
    //     IERC20(yfii).safeTransfer(burnAddress, _burnfee); //burn fee 5%

    //     if (strategyfee >0){
    //         uint _strategyfee = b.mul(strategyfee).div(max);
    //         IERC20(yfii).safeTransfer(strategyDev, _strategyfee);
    //     }
    // }
    
    // function _withdrawSome(uint256 _amount) internal returns (uint) {
    //     uint _d = _amount.mul(1e18).div(dERC20(d).getExchangeRate());
    //     uint _before = IERC20(d).balanceOf(address(this));
    //     dRewards(pool).withdraw(_d);
    //     uint _after = IERC20(d).balanceOf(address(this));
    //     uint _withdrew = _after.sub(_before);
    //     _before = IERC20(want).balanceOf(address(this));
    //     dERC20(d).redeem(address(this), _withdrew);
    //     _after = IERC20(want).balanceOf(address(this));
    //     _withdrew = _after.sub(_before);
    //     return _withdrew;
    // }
    
    // function balanceOfWant() public view returns (uint) {
    //     return IERC20(want).balanceOf(address(this));
    // }
    
    // function balanceOfPool() public view returns (uint) {
    //     return (dRewards(pool).balanceOf(address(this))).mul(dERC20(d).getExchangeRate()).div(1e18);
    // }
    
    // function getExchangeRate() public view returns (uint) {
    //     return dERC20(d).getExchangeRate();
    // }
    
    // function balanceOfD() public view returns (uint) {
    //     return dERC20(d).getTokenBalance(address(this));
    // }
    
    // function balanceOf() public view returns (uint) {
    //     return balanceOfWant()
    //            .add(balanceOfD())
    //            .add(balanceOfPool());
    // }
    
    // function setGovernance(address _governance) external {
    //     require(msg.sender == governance, "!governance");
    //     governance = _governance;
    // }
    
    // function setController(address _controller) external {
    //     require(msg.sender == governance, "!governance");
    //     controller = _controller;
    // }
    // function setFee(uint256 _fee) external{
    //     require(msg.sender == governance, "!governance");
    //     fee = _fee;
    // }
    // function setStrategyFee(uint256 _fee) external{
    //     require(msg.sender == governance, "!governance");
    //     strategyfee = _fee;
    // }
    // function setCallFee(uint256 _fee) external{
    //     require(msg.sender == governance, "!governance");
    //     callfee = _fee;
    // }
    // function setBurnFee(uint256 _fee) external{
    //     require(msg.sender == governance, "!governance");
    //     burnfee = _fee;
    // }
    // function setBurnAddress(address _burnAddress) public{
    //     require(msg.sender == governance, "!governance");
    //     burnAddress = _burnAddress;
    // }

    // function setWithdrawalFee(uint _withdrawalFee) external {
    //     require(msg.sender == governance, "!governance");
    //     require(_withdrawalFee <=100,"fee >= 1%"); //max:1%
    //     withdrawalFee = _withdrawalFee;
    // }
}