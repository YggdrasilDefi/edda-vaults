pragma solidity ^0.6.6;

interface IAave {
  function deposit(
    address _reserve,
    uint256 _amount,
    uint16 _referralCode
  ) external;
}
