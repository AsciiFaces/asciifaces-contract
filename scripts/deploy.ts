import { ethers, network } from "hardhat";

import { AsciiFaces__factory } from "../typechain";

async function main(): Promise<void> {
  const WethMockFactory = await ethers.getContractFactory("WETHMock");
  const AsciiFaceFactory: AsciiFaces__factory = await ethers.getContractFactory("AsciiFaces");

  const networkName = network.name;

  let WETH: string;

  if (networkName === "mainnet") {
    WETH = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";
  } else {
    const wethMock = await WethMockFactory.deploy();
    await wethMock.deployed();

    WETH = wethMock.address;
  }

  const asciiface = await AsciiFaceFactory.deploy(WETH);

  console.log("WETH Address : " + WETH);
  console.log("Contract deployed to: ", asciiface.address);
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
