// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { AsciiFaces } from "../typechain";
import { WETHMock } from "../typechain/WETHMock";
import { Signer } from "ethers";

declare module "mocha" {
  export interface Context {
    asciiface: AsciiFaces;
    mockETH: WETHMock;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: { [key: string]: Signer };
  }
}
