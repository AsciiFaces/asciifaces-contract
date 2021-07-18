import { parseUnits } from "ethers/lib/utils";
import { DeployFunction } from "hardhat-deploy/types";

const deploy: DeployFunction = async ({ deployments, getUnnamedAccounts }) => {
  const [deployer] = await getUnnamedAccounts();

  await deployments.deploy("AsciiFaces", {
    gasPrice: parseUnits("1", "gwei"),
    from: deployer,
    log: true,
  });
};

export default deploy;
