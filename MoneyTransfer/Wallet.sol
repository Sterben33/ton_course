pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {

    modifier checkUserAndAccept() {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }
    function sendWithPaidFee(address dest, uint128 amount, bool bounce) public view checkUserAndAccept {
        dest.transfer(amount, bounce, 1);
    }
    function sendWithoutFee(address dest, uint128 amount, bool bounce) public view checkUserAndAccept {
        dest.transfer(amount, bounce, 0);
    }
    function sendAllAndDeleteContract(address dest, uint128 amount, bool bounce) public view checkUserAndAccept {
        dest.transfer(amount, bounce, 160);
    }
}
