pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import 'BaseDebot.sol';

contract ShoppingDebot is BaseDebot {

    uint32 m_id;
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
                MenuItem("Show purchase list","",tvm.functionId(showPurchaseList)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase)),
                MenuItem("Make a purchase","",tvm.functionId(makeAPurchase))
            ]
        );
    }


    function makeAPurchase(uint32 index) public {
        index = index;
        if (m_summary.paidCount + m_summary.unpaidCount > 0) {
            Terminal.input(tvm.functionId(makeAPurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no purchases to delete");
            _menu();
        }
    }
    function makeAPurchase_(string value) public {
        (uint256 key,) = stoi(value);
        m_id = uint32(key);
        Terminal.input(tvm.functionId(makeAPurchase__), "Enter price to buy this:", false);
    }
    function makeAPurchase__(string value) public {
        (uint price,) = stoi(value);
        optional(uint) pubkey = 0;
        IPurchaselist(m_address).buy{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_id, price);
    }
}