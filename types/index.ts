import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

export interface Signers {
  admin: SignerWithAddress;
  bob?: SignerWithAddress;
  charlie?: SignerWithAddress;
}
