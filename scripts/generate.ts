import { ethers } from "hardhat";
import fs from "fs";
import { AsciiFaces } from "../typechain";

async function main(): Promise<void> {
  const contract = (await ethers.getContractAt(
    "AsciiFaces",
    "0xe86Eb3dC0d49898C46c204DEEB9e6A5C6859beB1",
  )) as AsciiFaces;

  const range = [...Array(300).keys()];

  const promise = range.map(seed => contract._createFace(seed));

  const result = await Promise.all(promise);

  const data = result.map((item, index) => ({
    [index]: item,
  }));

  fs.writeFileSync("data/result.json", JSON.stringify(data));
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
