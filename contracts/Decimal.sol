pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

library Decimal {
    using SafeMath for uint256;

    uint256 constant BASE = 10**18;

    function one()
        internal
        pure
        returns (uint256)
    {
        return BASE;
    }

    function onePlus(
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return d.add(BASE);
    }

    function mulFloor(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(d) / BASE;
    }

    function mulCeil(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return _divCeil(target.mul(d), BASE);
    }

    function divFloor(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return target.mul(BASE).div(d);
    }

    function divCeil(
        uint256 target,
        uint256 d
    )
        internal
        pure
        returns (uint256)
    {
        return _divCeil(target.mul(BASE), d);
    }

    // From another SafeMath implementation
    function _divCeil(
        uint256 a,
        uint256 b
    )
        internal
        pure
        returns (uint256)
    {
        uint256 quotient = a.div(b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }
}
