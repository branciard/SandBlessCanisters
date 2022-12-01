
import * as IPFS from 'ipfs-core';
import { asyncable } from 'svelte-asyncable';

let instance = null;

export const ipfs = asyncable(async () => {
    console.log("new ipfs instance")
    const ipfs = await IPFS.create();
    return  ipfs;
  },
  null);//readonly