pragma solidity ^0.6.6;

interface ICurveFi {
  function get_virtual_price() external view returns (uint256);
}
