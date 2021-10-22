pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract TaskList {

    struct task {
        string name;
        uint32 created;
        bool done;
    }

    mapping(uint8=>task) taskList;
    bool[] usedKeys;

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

    modifier keyExists(uint8 key) {
        require(taskList.exists(key), 103);
        _;
    }

    function getOpenTaskCount() public checkOwnerAndAccept returns(uint8 count){
        for (uint8 i = 0; i < usedKeys.length; i++) {
            if(usedKeys[i] == true && taskList[i].done == false) {
                count++;
            }
        }
        return count;
    }

    function getTaskList() public checkOwnerAndAccept returns(mapping (uint8=>task)){
        return taskList;
    }

    function addTask(string name) public checkOwnerAndAccept {
        for (uint8 i = 0; i < usedKeys.length; i++) {
            if(usedKeys[i] == false) {
                taskList[i] = task(name, now, false);
                usedKeys[i] = true;
                return;
            }
        }
        taskList[uint8(usedKeys.length)] = task(name, now, false);
        usedKeys.push(true);
    }

    function getDescription(uint8 key) public checkOwnerAndAccept keyExists(key) returns(task)  {
        return taskList[key];
    }

    function deleteTask(uint8 key) public checkOwnerAndAccept keyExists(key){
        if(key == usedKeys.length - 1) {
            delete taskList[key];
            usedKeys.pop();
        }
        else {
            delete taskList[key];
            usedKeys[key] = false;
        }
    }

    function markAsDone(uint8 key) public checkOwnerAndAccept keyExists(key){
        taskList[key].done = true;
    }
}
