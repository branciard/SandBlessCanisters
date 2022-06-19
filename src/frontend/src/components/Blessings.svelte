<script>
  import { AuthClient } from '@dfinity/auth-client';
  import { onMount, getContext } from 'svelte';
  import { auth, createActor } from '../store/auth';
  import ContentQRCode from './ContentQRCode.svelte';
  import Modal from 'svelte-simple-modal';

  let client;

  let whoami = $auth.actor.whoami();

  let blessings = [];

  let mintSuccess = false;

  onMount(async () => {
    client = await AuthClient.create();
    if (await client.isAuthenticated()) {
      handleAuth();
      await loadBlessingsCollection();
      mintSuccess = false;
    }
  });

  function handleAuth() {
    auth.update(() => ({
      loggedIn: true,
      actor: createActor({
        agentOptions: {
          identity: client.getIdentity(),
        },
      }),
    }));

    whoami = $auth.actor.whoami();
  }

  function login() {
    client.login({
      identityProvider:
        process.env.DFX_NETWORK === 'ic'
          ? 'https://identity.ic0.app/#authorize'
          : `http://${process.env.INTERNET_IDENTITY_CANISTER_ID}.localhost:8000/#authorize`,
      onSuccess: handleAuth,
    });
  }

  async function logout() {
    await client.logout();
    auth.update(() => ({
      loggedIn: false,
      actor: createActor(),
    }));

    whoami = $auth.actor.whoami();
  }

  async function newBless() {
    if ($auth.loggedIn) {
      // locationType 4 means embedded https://rustrepo.com/repo/Psychedelic-DIP721
      let metadata = [
        {
          // no metadata yet.
          data: [0],
          key_val_data: [
            { key: 'contentType', val: { TextContent: 'text/plain' } },
            { key: 'locationType', val: { Nat8Content: BigInt(4) } },
          ],
          purpose: { Rendered: null },
        },
      ];
      let principal = await $auth.actor.whoami();
      let result = await $auth.actor.mintDip721(principal, metadata);
      console.log('Result MintDip721 call :');
      console.log(result);
      await loadBlessingsCollection();
      mintSuccess = true;
    }
  }

  async function loadBlessingsCollection() {
    if ($auth.loggedIn) {
      let principal = await $auth.actor.whoami();
      blessings = await $auth.actor.getTokenIdsForUserDip721(principal);
    }
  }
</script>

<div class="box-info">
  {#await whoami}
    Querying caller identity...
  {:then principal}
    <div class="align-left">1</div>
    <div>Sand Bless Ceremony Priest Identity :</div>
    <div>
      <code>{principal}</code>
      {#if principal.isAnonymous()}
        (anonymous)
      {/if}
    </div>
  {/await}
  {#if $auth.loggedIn}
    <div>
      <button on:click={logout}>Log out from Sand Bless Ceremony</button>
    </div>
  {:else}
    <div>
      <button on:click={login}>Login and enter Sand Bless Ceremony</button>
    </div>
  {/if}
</div>

<div class="box-info">
  {#await whoami}
    Querying caller identity...
  {:then principal}
    <div class="align-left">2</div>
    {#if principal.isAnonymous()}
      <div>Login to pray and receive blessings.</div>
    {:else}
      <div>
        <button on:click={newBless}>Pray and receive blessed mark</button>
      </div>
      {#if mintSuccess}
        <div>New blessed mark received !</div>
      {:else}
        <div>&nbsp;</div>
      {/if}
    {/if}
  {/await}
</div>
<div class="box-info">
  {#await whoami}
    Querying caller identity...
  {:then principal}
    <div class="align-left">3</div>
    {#if principal.isAnonymous()}
      <div>Login to see your blessed marks collection.</div>
    {:else}
      <div>
        <button on:click={loadBlessingsCollection}>Load blessed marks</button>
      </div>
      <div>
        <table class="blessingsTab">
          <tr>
            <td>Blessed Mark Number</td>
            <td>Blessed Mark universal Link</td>
            <td>Blessed Mark universal QR Code</td>
          </tr>
          {#each blessings as bless, index}
            <tr>
              <td>{bless}</td>
              <td>
                <a
                  href={'https://' +
                    process.env.BACKEND_CANISTER_ID +
                    '.ic0.app?tokenid=' +
                    bless}
                  target="_blank"
                  class="cursor-pointer"
                  >{'https://' +
                    process.env.BACKEND_CANISTER_ID +
                    '.ic0.app?tokenid=' +
                    bless}</a
                >
                <div />
              </td>
              <td>
                <Modal>
                  <ContentQRCode tokenid={bless} />
                </Modal></td
              >
            </tr>
          {/each}
        </table>
      </div>
    {/if}
  {/await}
</div>

<style>
  .box-info {
    margin-top: 32px;
    border-style: ridge;
    border-color: var(--color-blue-sea);
  }
  .box-info div {
    margin: 10px;
  }
  .box-info {
    margin: 10px;
  }
  .align-left {
    text-align: left;
  }
  .blessingsTab {
    margin-left: auto;
    margin-right: auto;
    padding: 6px 10px;
  }
  .blessingsTab td {
    padding: 6px 10px;
    border-style: ridge;
    border-color: var(--color-blue-sea);
  }
</style>
