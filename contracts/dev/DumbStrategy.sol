/**
 *Submitted for verification at Etherscan.io on 2020-09-01
 */

pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../../interfaces/IeVault.sol";
import "../../interfaces/IController.sol";
import "../../interfaces/IStrategy.sol";
import "../../interfaces/IGemLike.sol";
import "../../interfaces/IManagerLike.sol";
import "../../interfaces/IVatLike.sol";
import "../../interfaces/IGemJoinLike.sol";
import "../../interfaces/IGNTJoinLike.sol";
import "../../interfaces/IDaiJoinLike.sol";
import "../../interfaces/IHopeLike.sol";
import "../../interfaces/IEndLike.sol";
import "../../interfaces/IJugLike.sol";
import "../../interfaces/IPotLike.sol";
import "../../interfaces/ISpotLike.sol";
import "../../interfaces/IOSMedianizer.sol";
import "../../interfaces/IUni.sol";

/*

 A strategy must implement the following calls;

 - deposit()
 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller
 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault
 - withdrawAll() - Controller | Vault role - withdraw should always return to vault
 - balanceOf()

 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller

*/

contract DumbStrategy {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  address public token;
  address public want;
  address public weth;

  uint256 public c = 20000;
  uint256 public c_safe = 30000;
  uint256 public constant c_base = 10000;

  uint256 public performanceFee = 500;
  uint256 public constant performanceMax = 10000;

  uint256 public withdrawalFee = 50;
  uint256 public constant withdrawalMax = 10000;

  uint256 public strategistReward = 5000;
  uint256 public constant strategistRewardMax = 10000;

  bytes32 public constant ilk = "ETH-A";

  address public governance;
  address public controller;
  address public strategist;
  address public harvester;

  uint256 public cdpId;

  constructor(
    address _controller,
    address _token,
    address _want,
    address _weth
  ) public {
    governance = msg.sender;
    strategist = msg.sender;
    harvester = msg.sender;
    controller = _controller;

    token = _token;
    want = _want;
    weth = _weth;

    _approveAll();
  }

  function getName() external pure returns (string memory) {
    return "DumbStrategy";
  }

  function _approveAll() internal {}

  function deposit() public {}

  // Controller only function for creating additional rewards from dust
  function withdraw(IERC20 _asset) external returns (uint256 balance) {
    require(msg.sender == controller, "!controller");
    require(want != address(_asset), "want");
    balance = _asset.balanceOf(address(this));
    _asset.safeTransfer(controller, balance);
    balance = 1;
  }

  // Withdraw partial funds, normally used with a vault withdrawal
  function withdraw(uint256 _amount) external {
    require(msg.sender == controller, "!controller");
    uint256 _balance = IERC20(want).balanceOf(address(this));
  }

  // Withdraw all funds, normally used when migrating strategies
  function withdrawAll() external returns (uint256 balance) {
    balance = 1;
  }

  function _withdrawAll() internal {}

  function balanceOf() public view returns (uint256) {
    return 1;
  }
}
