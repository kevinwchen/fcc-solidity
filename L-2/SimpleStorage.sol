// SPDX-License-Identifier: MIT

// compiles with any solidity version from 0.6.00 to 0.7.0
pragma solidity ^0.6.0;

contract SimpleStorage{

    // Initialise favouriteNumber to 0
    // public keyword defines the visibility of the function (external, public, internal, private)
    // visibility automatically gets set to internal if not defined
    uint256 favouriteNumber;

    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber;
    }

    // view, pure are two functions that don't need a transaction fee (not changing the state of the blockchain)
    // view to check the state of the blockchain
    // pure to do some sort of math or calculation
    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }
    //function dosomemath(uint256 favouriteNumber) public pure {
    //    favouriteNumber + favouriteNumber;
    //}



    // structs to create your own type with info within it
    struct People {
        uint256 favouriteNumber;
        string name;
    }

    People public person = People({favouriteNumber: 14, name: "Kevin"});

    // arrays
    People[] public people; // this is a dynamic array that can change in size if you add something in
    // People[1] public people; // this can only have a max of 1 person inside (fixed size)

    // mapping is a dictionary like data structure which takes some type of key and returns the variable it is mapped to
    mapping(string => uint256) public nameToFavouriteNumber;

    // two main ways to store information in solidity, either in 'memory' or 'storage'
    // 'memory' only stores during the execution of the function
    // 'storage' means it will persist after the function is executed
    // NB string is actually not a value but an array of bytes
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        people.push(People({favouriteNumber: _favouriteNumber, name: _name})); // .push adds onto the array
        // can also use people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}