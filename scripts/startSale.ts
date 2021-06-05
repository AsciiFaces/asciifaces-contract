import { ethers, network } from "hardhat";
import { AsciiFaces } from "../typechain";

async function main(): Promise<void> {
  const networkName = network.name;

  let nftAddress;

  if (networkName === "testnet") {
    nftAddress = "0xE46A0C1eb0BA3A030926CE7B8975D8512eCc32C5";
  } else {
    nftAddress = "0xe86Eb3dC0d49898C46c204DEEB9e6A5C6859beB1";
  }

  const contract = (await ethers.getContractAt("AsciiFaces", nftAddress)) as AsciiFaces;

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
