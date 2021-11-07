pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import 'Common.sol';

contract PurchaseList {
    /*
     * ERROR CODES
     * 100 - Unauthorized
     * 102 - task not found
     */

    uint256 m_ownerPubkey;
   
    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    uint32 m_count;
    mapping(uint32 => Purchase) m_purchaseList;



    function addToList(string title, uint64 _count) public onlyOwner {
        tvm.accept();
        m_count++;
        m_purchaseList[m_count] = Purchase({
            id: m_count, 
            title: title, 
            count: _count, 
            createdAt: uint64(now), 
            isBought: false, 
            totalPriceForAll: uint(0)
        });
    }

    function buy(uint32 id, uint _totalPriceForAll) public onlyOwner {
        require(m_purchaseList.exists(id), 102);
        tvm.accept();
        m_purchaseList[id].isBought = true;
        m_purchaseList[id].totalPriceForAll = _totalPriceForAll;
    }

    function deletePurchase(uint32 id) public onlyOwner {
        require(m_purchaseList.exists(id), 102);
        tvm.accept();
        delete m_purchaseList[id];
    }

    //
    // Get methods
    //

    function getPurchaseList() public view returns (Purchase[] purchaseList) {
        string title;
        uint64 count;
        uint64 createdAt;
        bool isBought;
        uint totalPriceForAll;

        for(uint32 i = 0; i <= m_count; i++) {
            if(m_purchaseList.exists(i)) {
                title = m_purchaseList[i].title;
                count = m_purchaseList[i].count;
                createdAt = m_purchaseList[i].createdAt;
                isBought = m_purchaseList[i].isBought;
                totalPriceForAll = m_purchaseList[i].totalPriceForAll;
                purchaseList.push(Purchase(i, title, count, createdAt, isBought, totalPriceForAll));
            }
       }
    }

    function getStat() public view returns (PurchaseSummary summary) {
        uint32 paidCount;
        uint32 unpaidCount;
        uint totalSum;

        for((, Purchase purchase) : m_purchaseList) {
            if  (purchase.isBought) {
                paidCount ++;
                totalSum += purchase.totalPriceForAll;
            } else {
                unpaidCount ++;
            }
        }
        summary = PurchaseSummary(paidCount, unpaidCount, totalSum);
    }
}
