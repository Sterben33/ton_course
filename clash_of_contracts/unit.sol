
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'gameObject.sol';
import 'baseStation.sol'; 


contract unit is gameObject{

    baseStation base;
    address baseAddr;
    
    function destroy(address killer) internal override accept {
        base.removeUnit(address(this));
        killer.transfer(1, false, 160);
    }
    
    function destroyFromBaseStation(address killer) external override accept {
        require(msg.sender == baseAddr, 101);
        killer.transfer(1, false, 160);
    }
}
