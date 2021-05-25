import { task } from "hardhat/config";
import { AsciiFaces } from "../typechain";

task("getFace", "get face by seed", async (_taskArgs, hre) => {
  const [admin] = await hre.ethers.getSigners();

  const asciifaces = <AsciiFaces>(
    await hre.ethers.getContractAt("AsciiFaces", "0xee85d401835561De62b874147Eca8A4Fe1D5cBFf", admin)
  );

  const name = await asciifaces.name();

  console.log(name);
});
