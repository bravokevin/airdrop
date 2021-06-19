const { expect } = require("chai");

describe("KevKev", function() {
  it("Admin initialize correctly", async () => {
    const KevKen = await ethers.getContractFactory("KevKen");
    const kevken = await KevKen.deploy();
    await kevken.deployed();

    const [owner] = await ethers.getSigners();

    expect(Number(await kevken.totalSupply())).to.equal(100000000  * 10 ** 18);
    
    console.log(owner.address)
    expect(Number(await kevken.balanceOf(owner.address))).to.equal(100000000  * 10 ** 18);

    expect(await kevken.name()).to.equal("KevKen");

    expect(await kevken.symbol()).to.equal("KVK");
  });
});
