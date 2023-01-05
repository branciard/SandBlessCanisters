<script>
  import ImageIPFSGateway from './ImageIPFSGateway.svelte';
  export let data;
  export let type;
</script>

<div class="max-w-sm rounded overflow-hidden shadow-lg">
  <div class="px-6 py-4">
    {#if type == 2}
      <ImageIPFSGateway
        gateway="https://gateway.pinata.cloud/ipfs/"
        cid={data.TextContent}
      />
      <div class="py-4 text-xs">
        {data.TextContent ? data.TextContent : ''}
      </div>
    {:else}
      <p class="text-gray-700 text-base">
        {data.TextContent ? data.TextContent : ''}
      </p>
    {/if}
  </div>
</div>
