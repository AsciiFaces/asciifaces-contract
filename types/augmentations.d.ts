// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { Signers } from "./";
import { AsciiFaces } from "../typechain";
import { WETHMock } from "../typechain/WETHMock";

declare module "mocha" {
  export interface Context {
    asciiface: AsciiFaces;
    mockETH: WETHMock;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
  }
}
