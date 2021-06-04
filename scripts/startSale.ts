import { ethers } from "hardhat";
import { AsciiFaces } from "../typechain";

async function main(): Promise<void> {
  const contract = (await ethers.getContractAt(
    "AsciiFaces",
    "0xe86Eb3dC0d49898C46c204DEEB9e6A5C6859beB1",
  )) as AsciiFaces;

  const tx = await contract.startSale();
  await tx.wait();

  console.log("Sale started");
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
