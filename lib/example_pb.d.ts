// package: lib.tsproto
// file: lib/example.proto

import * as jspb from "google-protobuf";

export class Example extends jspb.Message {
  getFoo(): string;
  setFoo(value: string): void;

  getBar(): number;
  setBar(value: number): void;

  serializeBinary(): Uint8Array;
  toObject(includeInstance?: boolean): Example.AsObject;
  static toObject(includeInstance: boolean, msg: Example): Example.AsObject;
  static extensions: {[key: number]: jspb.ExtensionFieldInfo<jspb.Message>};
  static extensionsBinary: {[key: number]: jspb.ExtensionFieldBinaryInfo<jspb.Message>};
  static serializeBinaryToWriter(message: Example, writer: jspb.BinaryWriter): void;
  static deserializeBinary(bytes: Uint8Array): Example;
  static deserializeBinaryFromReader(message: Example, reader: jspb.BinaryReader): Example;
}

export namespace Example {
  export type AsObject = {
    foo: string,
    bar: number,
  }
}

