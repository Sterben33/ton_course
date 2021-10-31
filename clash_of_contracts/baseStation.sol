pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'gameObject.sol'; 


contract baseStation is gameObject {

    mapping (address=>gameObject) addrToGameObject;
    address[] units;

    constructor() public accept {
        healthPoints = 50;
        defence = 8;
        power = 0;
    }

    function addUnit(address _unitAddress) external accept {
        addrToGameObject[_unitAddress] = gameObject(_unitAddress);
        units.push(_unitAddress);
    }

    function removeUnit(address _unitAddress) external accept {
        bool deleted = false;
        if(addrToGameObject.exists(_unitAddress)) {
            delete addrToGameObject[_unitAddress];
        
            for (uint i = 0; i < units.length; i++) {
                if (deleted && i < units.length - 1) {
                    units[i] = units[i + 1];
                }
                if (units[i] == _unitAddress) {
                    if (i!=units.length - 1){
                        units[i] = units[i + 1];
                    }
                }
            }
            units.pop();
        }
    }
    function destroy(address killer) override internal accept {
        for(uint i = 0; i < units.length; i++) {
            addrToGameObject[units[i]].destroyFromBaseStation(killer);
        }
        killer.transfer(1, false, 160);
    }
}
