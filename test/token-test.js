const { expect } = require("chai");


describe("KevKev", function() {
  it("Contract Initialized correctly", async () => {
    this.KevKen = await ethers.getContractFactory("KevKen");
    this.kevken = await this.KevKen.deploy();
    await this.kevken.deployed();

    const [owner] = await ethers.getSigners();

    expect(Number(await this.kevken.totalSupply())).to.equal(100000000  * 10 ** 18);

    expect(Number(await this.kevken.balanceOf(owner.address))).to.equal(100000000  * 10 ** 18);

    expect(await this.kevken.name()).to.equal("KevKen");

    expect(await this.kevken.symbol()).to.equal("KVK");
  });
});
