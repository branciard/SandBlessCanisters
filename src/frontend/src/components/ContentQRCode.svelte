<script>
  import { getContext } from 'svelte';
  import PopupQRCode from './PopupQRCode.svelte';

  const { open } = getContext('simple-modal');
  export let tokenid;
  const showQRCode = () =>
    open(PopupQRCode, {
      tokenid: tokenid,
    });
</script>

<p>
  <button on:click={showQRCode}>Show</button>
</p>
