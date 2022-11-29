<script>
  export let cid = null;
  export let ipfs = null;
  import Image from './Image.svelte';
  import * as IPFS from 'ipfs-core';

  let promise = loadImgURL(cid, 'image/png', 524288);

  async function loadImgURL(cid, mime, limit) {
    const data = [];
    if (ipfs == null) {
      console.log('No IPFS in props so start a new IPFS insance');
      ipfs = await IPFS.create({ repo: 'ok' + Math.random() });
    }

    // if (!ipfs && !cid) {
    let stream = ipfs.cat(cid);
    for await (const chunk of stream) {
      data.push(chunk);
    }
    // }
    return URL.createObjectURL(new Blob(data, { type: mime }));
  }
</script>

{#await promise}
  <img
    src="https://c.tenor.com/On7kvXhzml4AAAAi/loading-gif.gif"
    alt="Fetching IPFS data......"
  />
{:then src}
  <Image {src} />
{:catch error}
  <!-- promise was rejected -->
  <p>Error loading IPFS Image: {error}</p>
{/await}
