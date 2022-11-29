
import * as IPFS from 'ipfs-core';
import { asyncable } from 'svelte-asyncable';

// inspiration :
// https://svelte.dev/repl/d78d7327830442ab87cc47bcee1033f9?version=3.43.1
// https://svelte.dev/repl/dcc69ccad6c341e8b75ee38c3eac1524?version=3.53.1


export const ipfs = asyncable(async () => {
    console.log("new ipfs instance")
    const ipfs = await IPFS.create();
    return  ipfs;
  },
  null);//readonly