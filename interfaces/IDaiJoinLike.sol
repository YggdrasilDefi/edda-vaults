pragma solidity ^0.5.16;

import "./IGemLike.sol";
import "./IVatLike.sol";

interface IDaiJoinLike {
    function vat() external returns (IVatLike);
    function dai() external returns (IGemLike);
    function join(address, uint) external payable;
    function exit(address, uint) external;
}
