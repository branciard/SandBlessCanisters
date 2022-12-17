<script>
  import ImageIPFS from './ImageIPFS.svelte';
  import { onMount } from 'svelte';
  export let ipfs = null;
  export let cid;
  export let gateway;

  let loaded = false;
  let failed = false;
  let loading = false;
  let srcComposed;

  onMount(() => {
    const img = new Image();
    srcComposed = `${gateway}${cid}`;
    img.src = `${gateway}${cid}`;
    loading = true;

    img.onload = () => {
      loading = false;
      loaded = true;
    };
    img.onerror = () => {
      loading = false;
      failed = true;
    };
  });
</script>

{#if loaded}
  <img class="hover:grow hover:shadow-lg" src={srcComposed} alt="Document" />
{:else if failed}
  <ImageIPFS {ipfs} {cid} />
{:else if loading}
  <img
    class="hover:grow hover:shadow-lg"
    src="images/SandBlessLoading.gif"
    alt="Loading..."
  />
{/if}
