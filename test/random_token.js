const RandomToken = artifacts.require("RandomToken");
const assertLib = require('truffle-assertions');

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("RandomToken", function ( accounts ) {
  it("contract should increase price quadratically after batch mint", async function () {
    const randomTokenInstance = await RandomToken.deployed();
    const numMintTokens = 2;
    const costBefore = await randomTokenInstance.cost.call();

    const totalCost = await randomTokenInstance.getTotalMintCost.call(numMintTokens);

    await randomTokenInstance.mintToken(numMintTokens, {from: accounts[1], value: web3.utils.toWei(totalCost, 'wei')});

    const costAfter = await randomTokenInstance.cost.call();

    assert.notEqual(costBefore, costAfter, "Price should be incremented after mint");
    assert.equal(costAfter, 16,"Price is not quadratically incremented to be 16 wei");
  });

});

contract("RandomToken2", function ( accounts ) {
  it("contract deny minting if not enough fee.", async function () {
    const randomTokenInstance = await RandomToken.deployed();
    const numMintTokens = 1;
    await assertLib.reverts(randomTokenInstance.mintToken(numMintTokens, {from: accounts[2], value: web3.utils.toWei('1', 'wei')}));
  });

  it("contract should deny minting more than the remaining supply of Tokens", async function () {
    const randomTokenInstance = await RandomToken.deployed();
    let numMintTokens = 3;
    let totalCost = await randomTokenInstance.getTotalMintCost.call(numMintTokens);
    await randomTokenInstance.mintToken(numMintTokens, {from: accounts[1], value: web3.utils.toWei(totalCost, 'wei')});

    totalCost = await randomTokenInstance.getTotalMintCost.call(numMintTokens);
    await assertLib.reverts(randomTokenInstance.mintToken(numMintTokens, {from: accounts[2], value: web3.utils.toWei(totalCost, 'wei')}));
  });

  it("contract should deny minting more than the allowed amount per user", async function () {
    const randomTokenInstance = await RandomToken.deployed();
    let numMintTokens = 2;
    let totalCost = await randomTokenInstance.getTotalMintCost.call(numMintTokens);
    await randomTokenInstance.mintToken(numMintTokens, {from: accounts[3], value: web3.utils.toWei(totalCost, 'wei')});

    totalCost = await randomTokenInstance.getTotalMintCost.call(numMintTokens);
    await assertLib.reverts(randomTokenInstance.mintToken(numMintTokens, {from: accounts[3], value: web3.utils.toWei(totalCost, 'wei')}));
  });
});
