pragma solidity ^0.6.6;

interface IVatLike {
  function can(address, address) external view returns (uint256);

  function ilks(bytes32)
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint256,
      uint256
    );

  function dai(address) external view returns (uint256);

  function urns(bytes32, address) external view returns (uint256, uint256);

  function frob(
    bytes32,
    address,
    address,
    address,
    int256,
    int256
  ) external;

  function hope(address) external;

  function move(
    address,
    address,
    uint256
  ) external;
}
