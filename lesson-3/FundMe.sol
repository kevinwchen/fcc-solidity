// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
// 

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
  // Uses SafeMath library for all our uint256 definitions preventing overflows
  // Libraries are similar to contracts but they are only deployed once at a specific address and their code is reused
  // using A for B
  // can be used to attach library functions from library A to any type B in the context of a contract
  using SafeMathChainlink for uint256;

  // create a new mapping between addresses and value
  // see how much an invidual address has funded the contract
  mapping(address => uint256) public addressToAmountFunded;

  address[] public funders;

  address public owner;
  // constructor deploys with contract deployment
  constructor() public {
    owner = msg.sender;
  }

  function fund() public payable {
      // when we define a function as payable, this function can be used to pay for things
      // i.e. we can pay the contract and it can hold funds
      // every function call has an associated value with it
      // wei is the smallest unit of measure of ethereum
      uint256 minimumUSD = 50 * 10 ** 18; // minimum USD worth of ETH fundable to the contract
      
      // when a function reaches a require() statement, it checks conditions
      // it will either continue if satisfied or revert and give an error message that you choose
      require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!"); // good practice to use require
      addressToAmountFunded[msg.sender] += msg.value; // msg.sender and msg.value are keywords
      funders.push(msg.sender);
  }

  function getVersion() public view returns (uint256){
    // type visibility(skipped) name = interface(address)
    // 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e is the ETH/USD Rinkeby Testnet Chainlink pricefeed
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    return priceFeed.version();
  }

  // want to call latestRoundData int256 answer to get price feed
  function getPrice() public view returns (uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    (,int256 answer,,,) = priceFeed.latestRoundData();
    return uint256(answer * 10 ** 10);
    // gives 340556041506 (note has 8 decimals which can be called from decimals function)
    // multiply by 10^10 to give 18 decimals total (everything has 18 decimals)
    // after gives 3421454644190000000000
  }

  // 1 ether = 10^9 gwei = 10^18 wei
  // reads in ethAmount and returns ethAmountInUsd
  function getConversionRate (uint256 ethAmount) public view returns (uint256){
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount / (10 ** 18));
    return ethAmountInUsd;
  }

  // modifier is used to change the behaviour of a function in a declarative way
  modifier onlyOwner {
    require(msg.sender == owner); // this modifier checks the require first
    _; // underscore is the rest of the code
  }

  function withdraw() public payable onlyOwner {
    // .transfer function sends some amount of ETH to whoever its being called on
    // in this case its being sent to msg.sender
    // 'this' is a keyword that refers to the current contract you're in
    // address(this) gives you the address of the current contract
    // .balance checks the ether balance of whatever its being called on
    require(msg.sender == owner);
    msg.sender.transfer(address(this).balance);
    // need constructor to initiate an owner to the contract as soon as its deployed

    // initiate index at 0
    // loop through whilst index is within range of funders.length
    // make all mappings = 0 since funds have been withdrawn
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
      address funder = funders[funderIndex];
      addressToAmountFunded[funder] = 0;
    }
    
    // initiate array to 0
    funders = new address[](0); // easy way to reset array

  }
}