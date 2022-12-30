<script>
  import CanisterIds from '../components/CanisterIds.svelte';
  import { AuthClient } from '@dfinity/auth-client';
  import { auth, createActor } from '../store/auth';
  import { onMount } from 'svelte';
  import { quintOut } from 'svelte/easing';
  import { fade, draw } from 'svelte/transition';
  import { expand } from '../store/custom-transitions.js';
  import { createBlob, blobToBinaryString, blobToArrayBuffer } from 'blob-util';
  import moment from 'moment';
  import 'moment/locale/fr';

  //https://v1.tailwindcss.com/components/forms

  let client;
  let checkOk = false;
  let checkKo = false;

  let whoami = $auth.actor.whoami();

  let getMarksTotalCount = $auth.actor.getMarksTotalCount();
  let getImprintsTotalCount = $auth.actor.getImprintsTotalCount();
  let getMarksTreeSize = $auth.actor.getMarksTreeSize();
  let getImprintsTreeSize = $auth.actor.getImprintsTreeSize();
  let getImprintIdsByMarkIdTreeSize =
    $auth.actor.getImprintIdsByMarkIdTreeSize();
  let getMarkIdsByImprintIdTreeSize =
    $auth.actor.getMarkIdsByImprintIdTreeSize();

  let inputCheckValue;
  let inputAddImprintValue;
  let inputAddImprintTexteAreaValue = `Référence XX sablée par Francois Branciard SAND BLESS le XX sur`;

  let currentMarkId;
  let currentMarkCreatedWhen;
  let currentMarkCreatedBy;

  onMount(async () => {
    client = await AuthClient.create();
    if (await client.isAuthenticated()) {
      handleAuth();
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
    whoamiFct = $auth.actor.whoami();
  }

  function login() {
    client.login({
      identityProvider:
        process.env.DFX_NETWORK === 'ic'
          ? 'https://identity.ic0.app/#authorize'
          : `http://${process.env.INTERNET_IDENTITY_CANISTER_ID}.localhost:4943/#authorize`,
      onSuccess: handleAuth,
    });
  }

  async function logout() {
    await client.logout();
    auth.update(() => ({
      loggedIn: false,
      actor: createActor(),
    }));
    whoamiFct = $auth.actor.whoami();
  }

  async function createMark() {
    if ($auth.loggedIn) {
      console.log('createMark call');
      const data = createBlob(['hello world'], { type: 'text/plain' });
      const binData = await blobToBinaryString(data);
      console.log('createBlob hello world:' + binData);

      const prepareData = await blobToArrayBuffer(data);
      //...new Uint8Array(Buffer.from('testme', 'utf-8')
      let metadata = [
        {
          key: 'key',
          value: { TextContent: 'value' },
        },
      ];
      let result = await $auth.actor.createMark();
      console.log('createMark result:');
      console.log(result);
      try {
        const sandblessId = BigInt(result.id);
        await getMark(sandblessId);
      } catch (e) {
        console.log(e);
        console.log('fail to get mark created');
      }
    }
  }

  async function createImprint(
    inputAddImprintValue,
    inputAddImprintTexteAreaValue
  ) {
    if ($auth.loggedIn) {
      console.log('createImprint call');
      const data = createBlob(['hello world'], { type: 'text/plain' });
      const binData = await blobToBinaryString(data);
      console.log('createBlob hello world:' + binData);

      const prepareData = await blobToArrayBuffer(data);
      //...new Uint8Array(Buffer.from('testme', 'utf-8')

      let imprint = { TextContent: 'imprinttest-30dec-22-1' };

      let result = await $auth.actor.createImprint(
        [inputAddImprintValue],
        imprint,
        ['tag1']
      );
      console.log('createImprint result:');
      console.log(result);

      const getImprintIdsByMarkId = await $auth.actor.getImprintIdsByMarkId(
        inputAddImprintValue
      );
      console.log('getImprintIdsByMarkId result:');
      console.log(getImprintIdsByMarkId);
    }
  }

  async function getMark(sandblessId) {
    console.log('getMark:' + sandblessId);
    if (sandblessId) {
      const result = await $auth.actor.getMark(BigInt(sandblessId));
      console.log('get mark result :');
      if (result.Ok) {
        console.log('OK :');
        console.log(result);
        currentMarkId = result.Ok.id;
        currentMarkCreatedWhen = moment(
          Number(result.Ok.createdWhen.toString().substring(0, 13))
        )
          .locale('fr')
          .format('LLLL');
        currentMarkCreatedBy = result.Ok.createdBy;
      } else {
        console.log('not OK');
        console.log(result);
      }
    }
  }

  async function getImprintIdsByMarkId(markId) {
    console.log('getImprintByMarkId:' + markId);
    if (markId) {
      const result = await $auth.actor.getImprintIdsByMarkId(BigInt(markId));
      console.log('get getImprintByMarkId result :');
      console.log(result);
    }
  }

  async function isMarkExist(sandblessId) {
    console.log('isMarkExist:' + sandblessId);
    if (sandblessId) {
      let result = await $auth.actor.isMarkExist(BigInt(sandblessId));

      console.log(result);
      if (JSON.stringify(result) == 'true') {
        console.log('checkOK true');
        checkOk = true;
        checkKo = false;
        await getMark(sandblessId);
      } else {
        checkOk = false;
        checkKo = true;
      }
    }
  }
</script>

<div class="container mx-auto bg-white py-4 border-t border-gray-400">
  <section class="bg-white">
    <div
      class="w-full md:flex px-4 columns-1sm py-4 container mx-auto justify-left"
    >
      <div
        class="p-6 bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
      >
        <a href="#">
          <h5
            class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
          >
            Recherche marquage
          </h5>
        </a>
        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400" />

        <div class="mb-3 font-normal text-gray-700 dark:text-gray-400">
          <img
            on:click={login}
            src="images/ic-badge-powered-by-crypto_slim-transparent-dark-text.svg"
            alt="100% on-chain"
          />
        </div>

        <form class="w-full">
          <div class="flex items-center border-b border-blue-500 py-2">
            <input
              class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
              type="number"
              bind:value={inputCheckValue}
              placeholder="Numéro"
              aria-label="Numéro"
              required
            />
            {#if checkOk}
              <img
                class="flex-shrink-0 border-transparent border-4 text-blue-500 hover:text-blue-800 text-sm py-1 px-2 rounded"
                src="images/check.svg"
                alt="check OK"
              />
            {:else if checkKo}
              <img
                class="flex-shrink-0 border-transparent border-4 text-blue-500 hover:text-blue-800 text-sm py-1 px-2 rounded"
                src="images/x.svg"
                alt="check KO"
              />
            {:else}
              <img
                class="flex-shrink-0 border-transparent border-4 text-blue-500 hover:text-blue-800 text-sm py-1 px-2 rounded"
                src="images/search.svg"
                alt="search"
              />
            {/if}
            <button
              class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
              type="button"
              on:click={isMarkExist(inputCheckValue)}
            >
              Rechercher
            </button>
          </div>
        </form>

        {#if $auth.loggedIn}
          <div class="grid grid-cols-1 divide-y">
            <div class="py-4">
              {#await whoami}
                Querying caller identity...
              {:then principalResult}
                <div>Logged Principal :</div>
                <div>
                  <code>{principalResult}</code>
                  {#if principalResult.isAnonymous()}
                    (anonymous)
                  {/if}
                </div>
              {/await}
              <div>
                <button
                  class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                  on:click={logout}>Log out</button
                >
              </div>
              <div class="py-4">
                <button
                  class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                  on:click={createMark}>Creation nouveau marquage</button
                >
              </div>
              <div class="py-4">
                <textarea
                  class="
          form-control
          block
          w-full
          px-3
          py-1.5
          text-base
          font-normal
          text-gray-700
          bg-white bg-clip-padding
          border border-solid border-gray-300
          rounded
          transition
          ease-in-out
          m-0
          focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                  bind:value={inputAddImprintTexteAreaValue}
                />

                <form class="w-full">
                  <div class="flex items-center border-b border-blue-500 py-2">
                    <input
                      class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                      type="number"
                      bind:value={inputAddImprintValue}
                      placeholder="Numéro"
                      aria-label="Numéro"
                      required
                    />

                    <img
                      class="flex-shrink-0 border-transparent border-4 text-blue-500 hover:text-blue-800 text-sm py-1 px-2 rounded"
                      src="images/search.svg"
                      alt="search"
                    />

                    <button
                      class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                      type="button"
                      on:click={createImprint(
                        inputAddImprintValue,
                        inputAddImprintTexteAreaValue
                      )}
                    >
                      Ajouter Empreinte sur {inputAddImprintValue}
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        {/if}
      </div>
      <div class="w-full px-4">
        <div
          class="w-full p-6 bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
        >
          Sand Bless propose de graver des numéros uniques sur vos oeuvres ou
          supports.
          <br />
          Ce numéro est enregistré et référencé dans un registre numérique utilisant
          la technologie de "Canister" de
          <a
            href="https://dfinity.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Dfinity</a
          >.
          <br />
          A ce numéro est associé une liste d'"empreintes" temporelles certifiant
          les informations souhaitées.
          <br />
          Cette page permet de rechercher le numéro et de consulter le contenu associé
          en ligne.

          <br />
          {#await getMarksTotalCount}
            (Comptage des marquages en cours ... )
          {:then marksCounter}
            {#await getImprintsTotalCount}
              (Comptage des marquages en cours ... )
            {:then imprintsCounter}
              A ce jour, un total de <b> {BigInt(marksCounter)}</b> marquages
              uniques Sand Bless ont été gravés et référencés et
              <b> {BigInt(imprintsCounter)}</b> empreintes ont été ajoutées sur ces
              marquages.
            {/await}
          {/await}
        </div>
      </div>
    </div>
    {#if currentMarkId}
      <div class="flex py-2 container mx-auto justify-center">
        <div class="md:flex w-full">
          <div
            class="p-6 w-full bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
          >
            <a href="#">
              <h5
                class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
              >
                Le marquage numéro <b>{currentMarkId} </b>créé le {currentMarkCreatedWhen}
                à <b>3</b> empreintes
              </h5>
            </a>
            <p class="mb-3 font-normal text-gray-700 dark:text-gray-400" />
          </div>
        </div>
      </div>
    {/if}

    <div class="overflow-x-auto relative">
      <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
        <thead
          class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
        >
          <tr>
            <th scope="col" class="py-3 px-6"> Type Empreintes </th>
            <th scope="col" class="py-3 px-6"> Date </th>
            <th scope="col" class="py-3 px-6"> contenu </th>
            <th scope="col" class="py-3 px-6"> Marquage associé</th>
          </tr>
        </thead>
        <tbody>
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <th
              scope="row"
              class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
            >
              sablage Marque
            </th>
            <td class="py-4 px-6"> une date ici </td>
            <td class="py-4 px-6"> gravure et sablage sandbless id xx </td>
            <td class="py-4 px-6" />
          </tr>
          <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
            <th
              scope="row"
              class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
            >
              Creation collection
            </th>
            <td class="py-4 px-6"> une date ici </td>
            <td class="py-4 px-6"> création d'une collection de 6 verres </td>
            <td class="py-4 px-6"> 2,3,4,5,6 </td>
          </tr>
          <tr class="bg-white dark:bg-gray-800">
            <th
              scope="row"
              class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
            >
              Breve de comptoire
            </th>
            <td class="py-4 px-6"> une date ici </td>
            <td class="py-4 px-6"> Bien d'a cha peu font un grand tout. </td>
            <td class="py-4 px-6" />
          </tr>
        </tbody>
      </table>
    </div>

    <br />
    {#if $auth.loggedIn}
      {#await whoami}
        Querying caller identity...
      {:then principalResult}
        <div>Logged Principal :</div>
        <div>
          <code>{principalResult}</code>
          {#if principalResult.isAnonymous()}
            (anonymous)
          {/if}
        </div>
      {/await}
      <div>
        <button
          class="inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          on:click={logout}>Log out</button
        >
        <br />
        <br />
        <button
          class="inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          on:click={createMark}>Creation nouveau marquage</button
        >
        <br />

        <button
          class="inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          on:click={createMark}
          >Ajouter une empreinte temporelle et un message sur le marquage :</button
        >

        <br />

        <input
          class="inputBlessNumber"
          type="number"
          bind:value={inputAddImprintValue}
          placeholder="Sand Bless Id"
          required
        />

        <textarea
          class="
        form-control
        block
        w-full
        px-3
        py-1.5
        text-base
        font-normal
        text-gray-700
        bg-white bg-clip-padding
        border border-solid border-gray-300
        rounded
        transition
        ease-in-out
        m-0
        focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
          bind:value={inputAddImprintTexteAreaValue}
        />

        <button
          class="inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
          on:click={addImprint(
            inputAddImprintValue,
            inputAddImprintTexteAreaValue
          )}
          >Ajouter Empreinte associée au marquage {inputAddImprintValue}
        </button>
      </div>
    {/if}
    <CanisterIds />
    <br />
    <br />
    DEBUG :
    <br />
    getMarksTreeSize:
    {#await getMarksTreeSize then getMarksTreeSizeResult}
      {getMarksTreeSizeResult}
    {/await}
    <br />
    getMarksTotalCount:
    {#await getMarksTotalCount then getMarksTotalCountResult}
      {getMarksTotalCountResult}
      {#each Array(10) as _, index (index)}
        <li>
          Mark {index + 1} <br />
          {#await $auth.actor.getMark(BigInt(index + 1)) then getMarkResult}
            : {JSON.stringify(getMarkResult, (key, value) =>
              typeof value === 'bigint' ? value.toString() + 'n' : value
            )}
          {/await}
        </li>
      {/each}
    {/await}
    <br />
    getImprintsTreeSize :
    {#await getImprintsTreeSize then getImprintsTreeSizeResult}
      {getImprintsTreeSizeResult}
    {/await}
    <br />
    getImprintsTotalCount:
    {#await getImprintsTotalCount then getImprintsTotalCountResult}
      {getImprintsTotalCountResult}

      {#each Array(10) as _, index (index)}
        <li>
          Imprint {index + 1} <br />
          {#await $auth.actor.getImprint(BigInt(index + 1)) then getImprintResult}
            : {JSON.stringify(getImprintResult, (key, value) =>
              typeof value === 'bigint' ? value.toString() + 'n' : value
            )}
          {/await}
        </li>
      {/each}
    {/await}
    <br />
    getImprintIdsByMarkIdTreeSize :
    {#await getImprintIdsByMarkIdTreeSize then getImprintIdsByMarkIdTreeSizeResult}
      {getImprintIdsByMarkIdTreeSizeResult}
      {#each Array(10) as _, index (index)}
        <li>
          array {index + 1} :<br />
          {#await $auth.actor.getImprintIdsByMarkId(BigInt(index + 1)) then getImprintIdsByMarkIdResult}
            {getImprintIdsByMarkIdResult}
          {/await}
        </li>
      {/each}
    {/await}
    <br />
    getMarkIdsByImprintIdTreeSize :
    {#await getMarkIdsByImprintIdTreeSize then getMarkIdsByImprintIdTreeSizeResult}
      {getMarkIdsByImprintIdTreeSizeResult}
      {#each Array(10) as _, index (index)}
        <li>
          array {index + 1} :<br />
          {#await $auth.actor.getMarkIdsByImprintId(BigInt(index + 1)) then getMarkIdsByImprintIdResult}
            {getMarkIdsByImprintIdResult}
          {/await}
        </li>
      {/each}
    {/await}
    <br />
  </section>
</div>

<style>
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
