pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Multiplication {

    uint public mult = 1;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }
    
    function multiply(uint multiplier) public checkOwnerAndAccept {
        require(multiplier >= 1 && multiplier <= 10, 103);
        mult *= multiplier;
    }
}
