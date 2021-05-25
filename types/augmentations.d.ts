// eslint-disable @typescript-eslint/no-explicit-any
import { Fixture } from "ethereum-waffle";

import { Signers } from "./";
import { Greeter } from "../typechain/Greeter";
import { AsciiFaces } from "../typechain";

declare module "mocha" {
  export interface Context {
    greeter: Greeter;
    asciiface: AsciiFaces;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
  }
}
