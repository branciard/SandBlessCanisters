<script>
  export let ipfs = null;
  export let cid = null;
  export let mimeType = 'image/gif';
  import Image from './Image.svelte';

  let promise = loadImgURL(ipfs, cid, mimeType);

  async function loadImgURL(ipfs, cid, mimeType) {
    const data = [];
    console.log(cid);
    console.log(ipfs);
    if (ipfs !== null && cid !== null) {
      let stream = ipfs.cat(cid);
      for await (const chunk of stream) {
        data.push(chunk);
      }
    }
    return URL.createObjectURL(new Blob(data, { type: mimeType }));
  }
</script>

{#await promise}
  <img
    class="hover:grow hover:shadow-lg"
    src="images/SandBlessLoading.gif"
    alt="Fetching IPFS data......"
  />
{:then src}
  <Image {src} />
{:catch error}
  <!-- promise was rejected -->
  <p>Error loading IPFS Image: {error}</p>
{/await}
