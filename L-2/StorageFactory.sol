// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Equivalent to copy and pasting the contract code here, can choose which contract to deploy later if multiple exist
import  "./SimpleStorage.sol";

contract StorageFactory {
    // array to track address of deployed contracts
    SimpleStorage[] public simpleStorageArray; // initialise simple storage array

    function createSimpleStorageContract() public {
        // create object of type SimpleStorage contract, name it simpleStorage equal to a new SimpleStorage with no input
        // i.e. deploy another contract from this contract
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage); // append or push the newly created contract to the array
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // call functions from ./SimpleStorage.sol
        // Address
        // ABI Application Binary Interface
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
    }
}