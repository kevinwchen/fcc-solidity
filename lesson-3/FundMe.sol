// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// will import the chainlink npm (node package manager) from
// https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
// code pasted in below

interface AggregatorV3Interface {

  function decimals()
    external
    view
    returns (
      uint8
    );

  function description()
    external
    view
    returns (
      string memory
    );

  function version()
    external
    view
    returns (
      uint256
    );

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(
    uint80 _roundId
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}

contract FundMe {

    // create a new mapping between addresses and value
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // when we define a function as payable, this function can be used to pay for things
        // i.e. we can pay the contract and it can hold funds
        // every function call has an associated value with it
        // wei is the smallest unit of measure of ethereum
        addressToAmountFunded[msg.sender] += msg.value; // msg.sender and msg.value are keywords
        // what is the ETH -> USD conversion rate?
    }
}