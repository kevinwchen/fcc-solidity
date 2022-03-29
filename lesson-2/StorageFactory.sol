// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Equivalent to copy and pasting the contract code here, can choose which contract to deploy later if multiple exist
import  "./SimpleStorage.sol";

// contract StorageFactory {
// Inherit all functions from the SimpleStorage contract into StorageFactory
contract StorageFactory is SimpleStorage {
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
        // ABI Application Binary Interface: tells solidity and other programming languages how it can interact with another contract
        // function stores _simpleStorageNumber as favouriteNumber at location _simpleStorageIndex
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        simpleStorage.store(_simpleStorageNumber);
        // can shorten to:
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();
        // can shorten to:
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}