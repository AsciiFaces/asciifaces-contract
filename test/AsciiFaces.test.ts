import hre from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Signers } from "../types";
import { Artifact } from "hardhat/types";
import { AsciiFaces } from "../typechain";
import { deployContract } from "ethereum-waffle";
import { expect } from "chai";
import { WETHMock } from "../typechain/WETHMock";
import { ethers } from "ethers";

describe("AsciiFaces", () => {
  before(async function () {
    this.signers = {} as Signers;

    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    this.signers.admin = signers[0];
    this.signers.bob = signers[1];
  });

  beforeEach(async function () {
    const asciifaceArtifact: Artifact = await hre.artifacts.readArtifact("AsciiFaces");
    const wethMockArtifact: Artifact = await hre.artifacts.readArtifact("WETHMock");

    this.mockETH = <WETHMock>await deployContract(this.signers.admin, wethMockArtifact);
    this.asciiface = <AsciiFaces>await deployContract(this.signers.admin, asciifaceArtifact, [this.mockETH.address]);
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

      expect(totalSupply).to.be.gte(0);
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

      await expect(this.asciiface.createFace(122332)).to.be.reverted;
    });

    it("should mint token normally", async function () {
      await this.asciiface.startSale();
      await this.mockETH.approve(this.asciiface.address, ethers.utils.parseEther("0.2"));

      const balanceBefore = await this.asciiface.balanceOf(this.signers.admin.address);

      await this.asciiface.createFace(122332);

      const userBalance = await this.asciiface.balanceOf(this.signers.admin.address);

      expect(userBalance).to.be.gt(balanceBefore);
    });

    it("should revert when user have not enough WETH", async function () {
      await this.asciiface.startSale();

      await this.mockETH.connect(this.signers.bob).approve(this.asciiface.address, ethers.utils.parseEther("200000"));

      await expect(this.asciiface.connect(this.signers.bob).createFace(1)).to.be.reverted;
    });
  });

  describe("bonding curve price", function () {
    it("should get price correctly", async function () {
      await this.asciiface.startSale();
      await this.mockETH.approve(this.asciiface.address, ethers.utils.parseEther("100000"));

      // for (let i = 1; i <= 1000; i++) {
      //   expect(await this.asciiface.calculatePrice()).to.eq(ethers.utils.parseEther("0.025"));

      //   await expect(this.asciiface.createFace(i));

      //   const face = await this.asciiface.getFace(i);
      //   console.log(`minted face #${i} : ${face}`);
      // }

      // for (let i = 1001; i <= 2000; i++) {
      //   expect(await this.asciiface.calculatePrice()).to.eq(ethers.utils.parseEther("0.05"));

      //   await expect(this.asciiface.createFace(i));

      //   const face = await this.asciiface.getFace(i);
      //   console.log(`minted face #${i} : ${face}`);
      // }

      // for (let i = 2001; i <= 3000; i++) {
      //   expect(await this.asciiface.calculatePrice()).to.eq(ethers.utils.parseEther("0.1"));

      //   await expect(this.asciiface.createFace(i));

      //   const face = await this.asciiface.getFace(i);
      //   console.log(`minted face #${i} : ${face}`);
      // }

      // for (let i = 3001; i <= 4000; i++) {
      //   expect(await this.asciiface.calculatePrice()).to.eq(ethers.utils.parseEther("0.2"));

      //   await expect(this.asciiface.createFace(i));

      //   const face = await this.asciiface.getFace(i);
      //   console.log(`minted face #${i} : ${face}`);
      // }

      // for (let i = 4001; i <= 5000; i++) {
      //   expect(await this.asciiface.calculatePrice()).to.eq(ethers.utils.parseEther("0.4"));

      //   await expect(this.asciiface.createFace(i));

      //   const face = await this.asciiface.getFace(i);
      //   console.log(`minted face #${i} : ${face}`);
      // }
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
