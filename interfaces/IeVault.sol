pragma solidity ^0.5.16;

interface IeVault {
    function getPricePerFullShare() external view returns (uint);
    function balanceOf(address) external view returns (uint);
    function depositAll() external;
    function withdraw(uint _shares) external;
    function withdrawAll() external;
}
