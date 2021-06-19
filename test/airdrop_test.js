const { expect } = require("chai");

describe("Airdrop", async () => {


  before(async function () {
    this.Airdrop= await ethers.getContractFactory("Airdrop");
    accounts = await ethers.getSigners();
     KevKen = await ethers.getContractFactory("KevKen");
     kevken = await KevKen.deploy();

    await kevken.deployed();

  });

  beforeEach(async function () {
    this.airdropContract = await this.Airdrop.deploy(kevken.address,accounts[0].address);
    await this.airdropContract.deployed();

  });

  it("Admin initialize correctly", async () => {

    expect(await this.airdropContract.admin()).to.equal(accounts[0])

  });
});