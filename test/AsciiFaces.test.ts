import hre from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Signers } from "../types";
import { Artifact } from "hardhat/types";
import { AsciiFaces } from "../typechain";
import { deployContract } from "ethereum-waffle";
import { expect } from "chai";

describe("AsciiFaces", () => {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.bob = signers[1];
  });

  beforeEach(async function () {
    const asciifaceArtifact: Artifact = await hre.artifacts.readArtifact("AsciiFaces");
    this.asciiface = <AsciiFaces>await deployContract(this.signers.admin, asciifaceArtifact);
  });

  describe("Deploy Contract", function () {
    it("should Deploy contract correctly", async function () {
      const name = await this.asciiface.name();
      const symbol = await this.asciiface.symbol();

      expect(name).to.be.equal("AsciiFaces");
      expect(symbol).to.be.equal("ASF");
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
});
