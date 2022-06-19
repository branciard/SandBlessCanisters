<script>
  import { AuthClient } from '@dfinity/auth-client';
  import { onMount } from 'svelte';
  import { auth, createActor } from '../store/auth';
  import ContentQRCode from './ContentQRCode.svelte';
  import Modal from 'svelte-simple-modal';
  import { quintOut } from 'svelte/easing';
  import { fade, draw, fly } from 'svelte/transition';
  import { expand } from '../store/custom-transitions.js';

  let checkOK = false;

  let checkKo = false;

  let client;

  let whoami = $auth.actor.whoami();

  let dip721Name = '';

  let dip721Symbol = '';

  let inputValue;

  const urlParams = new URLSearchParams(window.location.search);
  const tokenidUrlParamToCheck = urlParams.has('tokenid');
  const tokenidUrlParamValue = urlParams.get('tokenid');

  onMount(async () => {
    client = await AuthClient.create();
    if (await client.isAuthenticated()) {
      handleAuth();
      await loadDip721NameAndSymbol();
      if (tokenidUrlParamToCheck) {
        inputValue = tokenidUrlParamValue;
        await checkBless(tokenidUrlParamValue);
      }
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

  async function loadDip721NameAndSymbol() {
    dip721Name = await $auth.actor.nameDip721();
    dip721Symbol = await $auth.actor.symbolDip721();
  }

  async function checkBless(tokenid) {
    if (tokenid) {
      let metadata = await $auth.actor.getMetadataDip721(BigInt(tokenid));
      if (metadata && Array.isArray(metadata.Ok) && metadata.Ok.length === 1) {
        checkOK = true;
        checkKo = false;
      } else {
        checkOK = false;
        checkKo = true;
      }
    } else {
      checkOK = false;
      checkKo = true;
    }
    await loadDip721NameAndSymbol();
  }

  /*function inputCheck() {
    // no negative values allowed
    if (inputValue < 0) {
      inputValue = 0;
    }
  }*/
</script>

<div class="box-info">
  <div class="align-left">4</div>

  <div>
    Blessed mark number :
    <input
      class="inputBlessNumber"
      type="number"
      bind:value={inputValue}
      placeholder="Mark number"
      required
    />
    <button on:click={() => checkBless(inputValue)}>Check</button>
  </div>
  <div class="wrapper">
    {#if checkOK}
      <svg
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:cc="http://creativecommons.org/ns#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:svg="http://www.w3.org/2000/svg"
        xmlns="http://www.w3.org/2000/svg"
        id="svg5046"
        version="1.1"
        viewBox="0 0 50 50"
        height="50mm"
        width="50mm"
      >
        <defs id="defs5040" />

        <g style="display:inline" id="background">
          <circle
            in:expand={{ duration: 1000, delay: 800, easing: quintOut }}
            r="12.111837"
            cy="272"
            cx="25"
            id="path5042"
            style="opacity:1;fill:#008849;fill-opacity:1;stroke:#008849;stroke-width:25;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1"
            transform="translate(0,-247)"
          />
        </g>

        <g style="display:inline" transform="translate(0,-247)" id="draw-line">
          <path
            in:draw={{ duration: 800 }}
            d="m 18.963249,271.54142 5.11928,5.88254 16.621216,-13.3733 c -4.624996,-7.33644 -9.696966,-10.5123 -18.398843,-9.418 -9.407725,1.18306 -15.8732057,10.07183 -14.7734199,19.63013 1.0997857,9.55831 9.3987219,16.23758 19.2969299,15.20827 11.395441,-1.18501 19.680898,-12.82477 13.875333,-25.4204"
            style="opacity:1;fill:none;stroke:#008849;stroke-width:4.84156466;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers"
            id="path5046"
          />
        </g>

        <g style="display:inline" id="white-fill">
          <path
            in:fade={{ delay: 800 }}
            d="m 18.963248,24.541422 5.11928,5.88254 16.621217,-13.3733 C 36.078748,9.7142223 31.006779,6.5383623 22.304901,7.6326623 12.897176,8.8157223 6.4316962,17.704492 7.5314812,27.262792 c 1.099786,9.55831 9.3987218,16.23758 19.2969298,15.20827 11.395442,-1.18501 19.6809,-12.82477 13.875334,-25.4204"
            style="display:inline;opacity:1;fill:none;stroke:#ffffff;stroke-width:4.84156513;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1;paint-order:stroke fill markers;fill-opacity:1"
            id="path5046-1"
          />
        </g>
      </svg>
    {/if}
    {#if checkKo}
      <svg
        xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
      >
        <path
          d="M 10,10 l 90,90 M 100,10 l -90,90"
          stroke="#f4a093"
          stroke-width="10"
        />
      </svg>
    {/if}
  </div>
  {#if checkOK && dip721Name && inputValue}
    <div>
      <div>
        Blessed marks collection name : {dip721Name}
      </div>
      <div>
        Blessed marks collection symbol : {dip721Symbol}
      </div>
      <div>Blessed Mark Number : {inputValue}</div>
      <div>Blessed Mark universal Link :</div>
      <div>
        <a
          href={'https://' +
            process.env.BACKEND_CANISTER_ID +
            '.ic0.app?tokenid=' +
            inputValue}
          target="_blank"
          class="cursor-pointer"
          >{'https://' +
            process.env.BACKEND_CANISTER_ID +
            '.ic0.app?tokenid=' +
            inputValue}</a
        >
      </div>
      <div>
        Blessed Mark universal QR Code
        <Modal>
          <ContentQRCode tokenid={inputValue} />
        </Modal>
      </div>
    </div>
  {/if}
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
  .inputBlessNumber {
    width: 15%;
  }
  svg {
    padding-top: 20px;
    padding-left: 20px;
    width: 20%;
    height: 20%;
  }
  path {
    fill: white;
    opacity: 1;
  }
</style>
