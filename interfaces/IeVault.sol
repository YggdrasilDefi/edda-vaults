pragma solidity ^0.6.6;

interface IeVault {
  function getPricePerFullShare() external view returns (uint256);

  function balanceOf(address) external view returns (uint256);

  function depositAll() external;

  function withdraw(uint256 _shares) external;

  function withdrawAll() external;
}
