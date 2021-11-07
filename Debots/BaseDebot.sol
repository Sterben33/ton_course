pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import 'AbstractPurchaseListDebot.sol';

contract BaseDebot is AbstractPurchaseListDebot {

    function _menu() internal virtual override {
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
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function showPurchaseList(uint32 index) public {
        index = index;
        optional(uint256) none;
        IPurchaselist(m_address).getPurchaseList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchaseList_),
            onErrorId: tvm.functionId(onError)
        }();
    }
    function showPurchaseList_(Purchase[] purchaseList) public {
        if (purchaseList.length > 0) {
            Terminal.print(0, "Your purchase list:");
            for (uint32 i = 0; i < purchaseList.length; i++) {
                Purchase purchase = purchaseList[i];
                string bought;
                uint totalPrice = 0;
                if (purchase.isBought) {
                    bought = '✓';
                    totalPrice = purchase.totalPriceForAll;
                } else {
                    bought = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" x{}  at {} with total price {}",
                    purchase.id,
                    bought,
                    purchase.title,
                    purchase.count,
                    purchase.createdAt,
                    totalPrice
                ));
            }
        } else {
            Terminal.print(0, "Your purchase list is empty");
        }
        _menu();
    }

    function deletePurchase(uint32 index) public {
        index = index;
        if (m_summary.paidCount + m_summary.unpaidCount > 0) {
            Terminal.input(tvm.functionId(deletePurchase_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no tasks to delete");
            _menu();
        }
    }
    function deletePurchase_(string value) public view {
        (uint256 key,) = stoi(value);
        optional(uint256) pubkey = 0;
        IPurchaselist(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(key));
    }
}