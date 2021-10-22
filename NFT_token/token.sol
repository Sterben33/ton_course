pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract token {

    struct CelebrityToken {
        string name;
        uint followers;
        uint netIncomePerMonth;
        uint32 countOfRealty;
    }

    CelebrityToken[] public celebArr;
    mapping (uint=>uint) public tokenToOwner;
    mapping (uint=>uint) public tokenToPrice;

    function createCelebrity(string _name, uint _followers, uint _netIncomePerMonth, uint32 _countOfRealty) external {
        uint lastIndex = celebArr.length;
        for (uint i = 0; i < lastIndex; i++) {
            require(celebArr[i].name != _name, 101);
        }
        tvm.accept();
        celebArr.push(CelebrityToken({
            name: _name,
            followers: _followers,
            netIncomePerMonth: _netIncomePerMonth,
            countOfRealty: _countOfRealty
        }));
        tokenToOwner[lastIndex + 1] = msg.pubkey();
    }

    function offerForSale(uint _tokenKey, uint _price) external {
        require(msg.pubkey() == tokenToOwner[_tokenKey], 102);
        tvm.accept();
        tokenToPrice[_tokenKey] = _price;
    }
}
