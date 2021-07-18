import hre from "hardhat";
import { expect } from "chai";
import { AsciiFaces } from "../typechain";

describe("AsciiFaces", () => {
  before(async function () {
    this.signers = {};

    const signers = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.bob = signers[1];

    hre.getUnnamedAccounts;
  });

  beforeEach(async function () {
    await hre.deployments.fixture(["AsciiFaces"]);

    const deployment = await hre.deployments.get("AsciiFaces");

    this.asciiface = (await hre.ethers.getContractAt(
      "AsciiFaces",
      deployment.address,
      this.signers.admin,
    )) as AsciiFaces;
  });

  describe("Deploy Contract", function () {
    it("should Deploy contract correctly", async function () {
      const name = await this.asciiface.name();
      const symbol = await this.asciiface.symbol();

      expect(name).to.be.equal("AsciiFaces");
      expect(symbol).to.be.equal("ASF");
    });

    it("should mint genesis token", async function () {
      const totalSupply = await this.asciiface.totalSupply();

      expect(totalSupply).to.be.eq(10);
    });
  });

  describe("Start / stop sale", function () {
    it("should start sale", async function () {
      await this.asciiface.startSale();
      const hasSaleStarted = await this.asciiface.hasSaleStarted();

      expect(hasSaleStarted).to.be.eq(true);
    });

    it("only allow owner to start sale", async function () {
      await expect(this.asciiface.connect(this.signers.bob).startSale()).to.be.reverted;
      await expect(this.asciiface.connect(this.signers.bob).pauseSale()).to.be.reverted;
    });
  });

  describe("minting", function () {
    it("should fail when sale is not started yet", async function () {
      await expect(this.asciiface.createFace(122322)).to.be.reverted;
    });

    it("should fail when weth is not approved yet", async function () {
      await this.asciiface.startSale();

      await expect(this.asciiface.createFace(122332));
    });

    it("should mint token normally", async function () {
      await this.asciiface.startSale();
      const balanceBefore = await this.asciiface.balanceOf(await this.signers.admin.getAddress());

      await this.asciiface.createFace(122332);

      const userBalance = await this.asciiface.balanceOf(await this.signers.admin.getAddress());

      expect(userBalance).to.be.gt(balanceBefore);
    });
  });

  describe("ERC721 Metadata", function () {
    describe("Token URI", function () {
      it("return api string by default", async function () {
        expect(await this.asciiface.tokenURI(1)).to.be.equal("https://api.asciifaces.com/face/1");
      });

      it("should revert to query nonexistent token id ", async function () {
        await expect(this.asciiface.tokenURI(10000)).to.be.reverted;
      });
    });

    describe("Base URI", function () {
      const baseUri = "https://api.com/face/";

      it("base uri can be set", async function () {
        await this.asciiface.setBaseURI(baseUri);

        expect(await this.asciiface.baseURI()).to.be.eq(baseUri);
      });

      it("base uri can not be changed by non-owner", async function () {
        await expect(this.asciiface.connect(this.signers.bob).setBaseURI(baseUri)).to.be.reverted;
      });
    });
  });
});
