
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'unit.sol';
import 'baseStation.sol';

contract warrior is unit{
    constructor(address _base) public accept {
        base = baseStation(_base);
        baseAddr = _base;
        base.addUnit(address(this));
        healthPoints = 20;
        power = 8;
        defence = 5;
    }
}
