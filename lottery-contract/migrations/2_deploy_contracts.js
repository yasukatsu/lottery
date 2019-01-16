const lottery = artifacts.require('../contracts/lottery.sol');

 module.exports = function (deployer, network, accounts) {
   return deployer
    .then(() => {
      return deployer.deploy(lottery);
    })
 }
