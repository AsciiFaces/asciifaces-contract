/* eslint-disable no-undef */
module.exports = async function ({ getUnnamedAccounts, deployments }) {
  const { deploy } = deployments;

  const [deployer] = await getUnnamedAccounts();

  await deploy("AsciiFaces", {
    from: deployer,
    log: true,
    deterministicDeployment: false,
  });
};

module.exports.tags = ["AsciiFaces"];
