/**
 *Submitted for verification at Etherscan.io on 2020-08-23
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../interfaces/IOneSplitAudit.sol";
import "../interfaces/IRewardDistributionRecipient.sol";

contract TreasuryVault {
    using SafeERC20 for IERC20;
    
    address public governance;
    address public onesplit = address(0x50FDA034C0Ce7a8f7EFDAebDA7Aa7cA21CC1267e);
    address public rewards;
    address public egov;
    
    mapping(address => bool) authorized;
    
    constructor() public {
        governance = msg.sender;
    }
    
    function setOnesplit(address _onesplit) external {
        require(msg.sender == governance, "!governance");
        onesplit = _onesplit;
    }
    
    function setRewards(address _rewards) external {
        require(msg.sender == governance, "!governance");
        rewards = _rewards;
    }
    
    function setEGov(address _egov) external {
        require(msg.sender == governance, "!governance");
        egov = _egov;
    }
    
    function setAuthorized(address _authorized) external {
        require(msg.sender == governance, "!governance");
        authorized[_authorized] = true;
    }
    
    function revokeAuthorized(address _authorized) external {
        require(msg.sender == governance, "!governance");
        authorized[_authorized] = false;
    }
    
    function setGovernance(address _governance) external {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function toGovernance(address _token, uint _amount) external {
        require(msg.sender == governance, "!governance");
        IERC20(_token).safeTransfer(governance, _amount);
    }
    
    function toVoters() external {
        require(rewards != address(0), "!rewards");
        require(egov != address(0), "!gov");
        uint _balance = IERC20(rewards).balanceOf(address(this));
        IERC20(rewards).safeApprove(egov, 0);
        IERC20(rewards).safeApprove(egov, _balance);
        IRewardDistributionRecipient(egov).notifyRewardAmount(_balance);
    }
    
    function getExpectedReturn(address _from, address _to, uint parts) external view returns (uint expected) {
        uint _balance = IERC20(_from).balanceOf(address(this));
        (expected,) = IOneSplitAudit(onesplit).getExpectedReturn(_from, _to, _balance, parts, 0);
    }
    
    // Only allows to withdraw non-core strategy tokens ~ this is over and above normal yield
    function convert(address _from, uint parts) external {
        require(authorized[msg.sender]==true, "!authorized");
        require(rewards != address(0), "!rewards");

        uint _amount = IERC20(_from).balanceOf(address(this));
        uint[] memory _distribution;
        uint _expected;
        IERC20(_from).safeApprove(onesplit, 0);
        IERC20(_from).safeApprove(onesplit, _amount);
        (_expected, _distribution) = IOneSplitAudit(onesplit).getExpectedReturn(_from, rewards, _amount, parts, 0);
        IOneSplitAudit(onesplit).swap(_from, rewards, _amount, _expected, _distribution, 0);
    }
}