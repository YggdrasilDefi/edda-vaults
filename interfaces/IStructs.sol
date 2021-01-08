pragma solidity ^0.6.6;

contract IStructs {
  struct Val {
    uint256 value;
  }

  enum ActionType {
    Deposit, // supply tokens
    Withdraw // borrow tokens
  }

  struct Asset {
    address lendingPool;
    address priceOralce;
    address interestModel;
  }

  enum AssetDenomination {
    Wei // the amount is denominated in wei
  }

  enum AssetReference {
    Delta // the amount is given as a delta from the current value
  }

  struct AssetAmount {
    bool sign; // true if positive
    AssetDenomination denomination;
    AssetReference ref;
    uint256 value;
  }

  struct ActionArgs {
    ActionType actionType;
    uint256 accountId;
    AssetAmount amount;
    uint256 primaryMarketId;
    uint256 secondaryMarketId;
    address otherAddress;
    uint256 otherAccountId;
    bytes data;
  }

  struct Info {
    address owner; // The address that owns the account
    uint256 number; // A nonce that allows a single address to control many accounts
  }

  struct Wei {
    bool sign; // true if positive
    uint256 value;
  }
}
