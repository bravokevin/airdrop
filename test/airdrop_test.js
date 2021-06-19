const { expect } = require('chai');

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

  it('Should initialized correctly', async function () {

    expect(await this.airdropContract.admin()).to.equal(owner.address);

    expect(await this.airdropContract.token()).to.equal(this.kevken.address)

  });

  it("should allows admin add new admin", async function () {
    await this.airdropContract.updateAdmin(accounts[2].address, { from: owner.address })
    expect(await this.airdropContract.admin()).to.equal(accounts[2].address)

  });

  // it("should not allowed other accounts to set new admins", async function () {
  //   await this.airdropContract.updateAdmin(accounts[2].address, { from: accounts[2].address})

  // })
});