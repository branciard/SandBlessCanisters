<script>
  import { AuthClient } from '@dfinity/auth-client';
  import { onMount } from 'svelte';
  import { auth, createActor } from '../store/auth';
  import ContentQRCode from './ContentQRCode.svelte';
  import Modal from 'svelte-simple-modal';
  import { Principal } from '@dfinity/principal';
  import { fly, fade } from 'svelte/transition';

  let client;

  let whoami = $auth.actor.whoami();

  let hasError = false;
  let errMessage = 'Error';
  let isSuccessVisibleNewBless = false;
  let isSuccessVisibleLoad = false;

  let submitted = false;

  let priestMarksToLoad;

  let blessings = [];

  let mintSuccess = false;
  let loadSuccess = false;

  onMount(async () => {
    client = await AuthClient.create();
    if (await client.isAuthenticated()) {
      handleAuth();
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

  function handleSubmitNewBless(e) {
    isSuccessVisibleNewBless = true;

    setTimeout(function () {
      isSuccessVisibleNewBless = false;
    }, 8000);
  }

  function handleSubmitLoad(e) {
    isSuccessVisibleLoad = true;

    setTimeout(function () {
      isSuccessVisibleLoad = false;
    }, 4000);
  }

  async function newBless() {
    if ($auth.loggedIn) {
      mintSuccess = false;
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
      mintSuccess = true;
    }
  }

  async function loadBlessingsCollection(priest) {
    submitted = true;
    let principal;
    let parsing = false;
    loadSuccess = false;
    try {
      principal = Principal.fromText(priest);
      parsing = true;
    } catch (e) {
      parsing = false;
    }
    if (parsing) {
      blessings = [];
      blessings = await $auth.actor.getTokenIdsForUserDip721(principal);
      if (blessings.length < 1) {
        hasError = true;
        errMessage = 'No blessed Mark found.';
      } else {
        loadSuccess = true;
        hasError = false;
        errMessage = '';
      }
    } else {
      hasError = true;
      errMessage = 'Wrong Priest Identity format.';
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
        <form
          id="loadForm"
          class="mt-4"
          class:submitted
          on:submit|preventDefault={handleSubmitNewBless}
        >
          <button on:click={newBless}>Pray and receive blessed mark</button>
          {#if mintSuccess && isSuccessVisibleNewBless}
            <span class="success-alert" transition:fade={{ duration: 150 }}>
              New blessed mark received !
            </span>
          {/if}
        </form>
      </div>
      <div>&nbsp;</div>
    {/if}
  {/await}
</div>
<div class="box-info">
  {#await whoami}
    Querying caller identity...
  {:then principal}
    <div class="align-left">3</div>
    <form
      id="loadForm"
      class="mt-4"
      class:submitted
      on:submit|preventDefault={handleSubmitLoad}
    >
      <div class="form-group">
        <input
          type="text"
          class="form-control"
          bind:value={priestMarksToLoad}
          placeholder="Priest Identity"
          required
        />
      </div>
      <div>
        <button on:click={loadBlessingsCollection(priestMarksToLoad)}
          >Load Priest blessed marks</button
        >
        {#if hasError == true}
          <span class="error-alert">{errMessage}</span>
        {:else if loadSuccess && isSuccessVisibleLoad}
          <span class="success-alert" transition:fade={{ duration: 150 }}>
            {blessings.length} Blessed Marks found !
          </span>
        {/if}
      </div>
    </form>

    {#if blessings.length > 0}
      <div>
        <table class="blessingsTab">
          <tr>
            <td>Blessed Mark Number</td>
            <td>Blessed Universal Mark</td>
          </tr>
          {#each blessings as bless, index}
            <tr>
              <td>{bless}</td>
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
  .form-group > * {
    width: 520px;
  }

  .form-control {
    border-radius: 3px;
  }

  .submitted input:invalid {
    border: 1px solid #c00;
  }

  .submitted input:focus:invalid {
    outline: 1px solid #c00;
  }

  .error-alert {
    border: 1px solid #c00 !important;
    padding: 6px;
    text-align: center;
    color: #c00;
    border-radius: 3px;
  }
  .success-alert {
    border: 1px solid #4bb543 !important;
    padding: 6px;
    text-align: center;
    color: #4bb543;
    border-radius: 3px;
  }
</style>
