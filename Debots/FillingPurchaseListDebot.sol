pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import 'BaseDebot.sol';

contract FillingPurchaseListDebot is BaseDebot {

    string m_title;
    uint64 m_count;
    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (paid/unpaid/total) purchases with total price = {} : ",
                    m_summary.paidCount,
                    m_summary.unpaidCount,
                    m_summary.paidCount + m_summary.unpaidCount,
                    m_summary.totalSum
            ),
            sep,
            [
                MenuItem("Add product to shopping basket","",tvm.functionId(addNewPurchaseToList)),
                MenuItem("Show purchase list","",tvm.functionId(showPurchaseList)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function addNewPurchaseToList(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(getTitleName), "Title of the product: ", false);
    }

    function getTitleName(string value) public {
        m_title = value;
        Terminal.input(tvm.functionId(getCount), "Count of product: ", false);
    }

    function getCount(string value) public {
        (uint tempCount,) = stoi(value);
        m_count = uint64(tempCount);
        optional(uint256) none;
        IPurchaselist(m_address).addToList{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(m_title, m_count);
    }
}