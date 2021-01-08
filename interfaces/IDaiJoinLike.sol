pragma solidity ^0.6.6;

import "./IGemLike.sol";
import "./IVatLike.sol";

interface IDaiJoinLike {
  function vat() external returns (IVatLike);

  function dai() external returns (IGemLike);

  function join(address, uint256) external payable;

  function exit(address, uint256) external;
}
