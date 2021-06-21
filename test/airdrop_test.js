const { expect, assert } = require('chai');

const { expectRevert } = require('@openzeppelin/test-helpers');

describe('Airdrop', function () {
  before(async function () {
    [owner, ...accounts] = await ethers.getSigners();
    this.Airdrop = await ethers.getContractFactory("Airdrop");

    this.KevKen = await ethers.getContractFactory("KevKen");
    this.kevken = await this.KevKen.deploy();
    await this.kevken.deployed();
  });

  beforeEach(async function () {
    this.airdropContract = await this.Airdrop.deploy(this.kevken.address, owner.address);
    await this.airdropContract.deployed();
  });


  // const createSignature = params =>{
  //   params = {recipient: account[1], amount:100, ...params};

  //   const message = ethers.utils.keccak256(
  //     {t: 'address', v: params.recipient},
  //     {t: 'uint256', v: params.amount}
  //   ).toString("hex");

  //   const signature = signer.signMessage(message)
  //     console.log(`this is the signature ${signature}`)
  // }

  it('Should initialized correctly', async function () {

    expect(await this.airdropContract.admin()).to.equal(owner.address);

    expect(await this.airdropContract.token()).to.equal(this.kevken.address)

  });

  it("should allows admin add new admin", async function () {
    await this.airdropContract.updateAdmin(accounts[2].address, { from: owner.address })
    expect(await this.airdropContract.admin()).to.equal(accounts[2].address)

  });

  // it("should not allowed other accounts to set new admins", async function () {

  //   await expectRevert(
  //     this.airdropContract.connect(accounts[2]).updateAdmin(accounts[2].address, { from: accounts[2].address }),
  //     // "Only the admin is awllowed to call this function"
  //   )
      
  // })
});