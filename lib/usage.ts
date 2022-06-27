/**
 * @fileoverview Example of proto building, using example.proto
 */

 import { Example } from "__main__/lib/example_pb";

 /** Create a new Example */
 export function newExample(foo: string, bar: number): Example {
   const ex = new Example();
   ex.setFoo(foo);
   ex.setBar(bar);
   return ex;
 }
 