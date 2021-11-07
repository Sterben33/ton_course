pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;


struct Purchase {
    uint32 id;
    string title;
    uint64 count;
    uint64 createdAt;
    bool isBought;
    uint totalPriceForAll;
}

struct PurchaseSummary {
    uint32 paidCount;
    uint32 unpaidCount;
    uint totalSum;

}

interface Transactable {
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}


abstract contract HasConstructorWithPubKey {
   constructor(uint256 pubkey) public {}
}

interface IPurchaselist {
    function getStat() external returns (PurchaseSummary);
    function getPurchaseList() external returns (Purchase[]);
    function deletePurchase(uint32 id) external;
    function buy(uint32 id, uint _totalPriceForAll) external;
    function addToList(string title, uint64 count) external;

}