// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// will import the chainlink npm (node package manager) from
// https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
// code has been pasted in below

// note the functions are not completed

// Anytime you want to interact with an already deployed smart contract you will need an ABI
// Interfaces compile down to an ABI
// Always need an ABI to interact with a contract

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

  function getVersion() public view returns (uint256){
    // type visibility(skipped) name = interface(address)
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    return priceFeed.version();
  }

  // want to call latestRoundData int256 answer to get price feed
  function getPrice() public view returns (uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    (,int256 answer,,,) = priceFeed.latestRoundData();
    return uint256(answer * 10000000000);
    // gives 340556041506 (note has 8 decimals which can be called from decimals function)
    // multiply by 10^10 to give 18 decimals total
    // after gives 3421454644190000000000
  }

  // 1 gwei = 1000000000 wei (10^9)
  // reads in ethAmount and returns ethAmountInUsd
  function getConversionRate (uint256 ethAmount) public view returns (uint256){
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount / 1000000000000000000);
    return ethAmountInUsd;
  }
}