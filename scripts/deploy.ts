import { ethers } from "hardhat";

import { AsciiFaces__factory } from "../typechain";

async function main(): Promise<void> {
  const WethMockFactory = await ethers.getContractFactory("WETHMock");
  const AsciiFaceFactory: AsciiFaces__factory = await ethers.getContractFactory("AsciiFaces");

  const wethMock = await WethMockFactory.deploy();
  await wethMock.deployed();

  const asciiface = await AsciiFaceFactory.deploy(wethMock.address);

  console.log("Greeter deployed to: ", asciiface.address);
}

// We recommend this pattern to be able to use async/await everywhere and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
