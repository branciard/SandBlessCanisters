<script>
  import ImprintData from '../components/ImprintData.svelte';
  import ImprintType from '../components/ImprintType.svelte';

  import { AuthClient } from '@dfinity/auth-client';
  import { auth, createActor } from '../store/auth';
  import { IMPRINT_TYPE_ENUM } from '../store/constants';
  import { onMount } from 'svelte';

  import { createBlob, blobToBinaryString, blobToArrayBuffer } from 'blob-util';
  import moment from 'moment';

  import 'moment/locale/fr';

  import { writable } from 'svelte/store';

  //https://v1.tailwindcss.com/components/forms

  let client;
  let checkOk = false;
  let checkKo = false;

  let getMarksTotalCount = $auth.actor.getMarksTotalCount();
  let getImprintsTotalCount = $auth.actor.getImprintsTotalCount();

  // intpus froms
  let imprintTypeSelect = [
    { id: 'Comment', text: IMPRINT_TYPE_ENUM.Comment },
    { id: 'PubJoke', text: IMPRINT_TYPE_ENUM.PubJoke },
    { id: 'ImageIPFS', text: IMPRINT_TYPE_ENUM.ImageIPFS },
    { id: 'SandblastingMark', text: IMPRINT_TYPE_ENUM.SandblastingMark },
  ];

  let selectedImprintType = imprintTypeSelect[0].id;

  let inputCheckValue;
  let inputAddImprintValue;
  let inputAddImprintTexteAreaValue = ``;

  const inputsAssociatedMarks = writable([]);

  const addAssociatedMark = (inputAddImprintValue) => {
    $inputsAssociatedMarks = [...$inputsAssociatedMarks, inputAddImprintValue];
  };

  function resetinputsAssociatedMarks() {
    $inputsAssociatedMarks = [];
  }

  let currentMarkId;
  let currentMarkCreatedWhen;
  let currentMarkCreatedBy;

  let imprints = [];

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
  }

  function login() {
    client.login({
      identityProvider:
        process.env.DFX_NETWORK === 'ic'
          ? 'https://identity.ic0.app/#authorize'
          : `http://${process.env.INTERNET_IDENTITY_CANISTER_ID}.localhost:4943/#authorize`,
      onSuccess: async () => {
        client = await AuthClient.create();
        if (await client.isAuthenticated()) {
          handleAuth();
        }
      },
    });
  }

  function formatCanisterDate(canisterDate) {
    return moment(Number(canisterDate.toString().substring(0, 13)))
      .locale('fr')
      .format('Do MMMM YYYY à HH:mm:ss');
  }

  async function logout() {
    await client.logout();
    auth.update(() => ({
      loggedIn: false,
      actor: createActor(),
    }));
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
        const markId = BigInt(result.id);
        await getMark(markId);
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

      let imprint = {
        TextContent: 'QmUkmxC4Ciz53g7b6oZY17ZejT1Q6VdgjR7pp2caDWSoR3',
      };

      let imprintType = 'ImageIPFS';

      let result = await $auth.actor.createImprint(
        [inputAddImprintValue],
        imprintType,
        imprint
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

  async function getMark(markId) {
    console.log('getMark:' + markId);
    if (markId) {
      const result = await $auth.actor.getMark(BigInt(markId));
      console.log('get mark result :');
      if (result.Ok) {
        console.log('OK :');
        console.log(result);
        currentMarkId = result.Ok.id;
        currentMarkCreatedWhen = formatCanisterDate(result.Ok.createdWhen);
        currentMarkCreatedBy = result.Ok.createdBy;
        await getImprintsByMarkId(markId);
      } else {
        console.log('not OK');
        console.log(result);
      }
    }
  }

  async function getImprintsByMarkId(markId) {
    console.log('getImprintsByMarkId:' + markId);
    if (markId) {
      const loadImprints = [];
      const result = await $auth.actor.getImprintIdsByMarkId(BigInt(markId));
      console.log('getImprintsByMarkId result :');
      console.log(result);
      for (let array of result) {
        console.log(array);
        for (let imprintId of array) {
          console.log(imprintId);
          const imprintsResult = await $auth.actor.getImprint(
            BigInt(imprintId)
          );

          if (imprintsResult.Ok) {
            loadImprints.push(imprintsResult.Ok);
            console.log(imprintsResult.Ok);
          }
        }
      }
      imprints = loadImprints;
      console.log(loadImprints);
    }
  }

  async function purgeCanister() {
    console.log('purgeCanister');
    let result = await $auth.actor.purgeCanister();
    console.log(result);
  }

  async function isMarkExist(markId) {
    console.log('isMarkExist:' + markId);
    if (markId) {
      let result = await $auth.actor.isMarkExist(BigInt(markId));

      console.log(result);
      if (JSON.stringify(result) == 'true') {
        console.log('checkOK true');
        checkOk = true;
        checkKo = false;
        await getMark(markId);
      } else {
        checkOk = false;
        checkKo = true;
      }
    }
  }
  //https://layoutsfortailwind.lalokalabs.dev/ui/flex-grid
</script>

<div class="container mx-auto bg-white py-4 border-t border-gray-400">
  <section class="bg-white">
    <div class="flex flex-wrap -mb-4 -mx-2">
      <div class="w-full mb-4 px-2">
        <div class="flex items-center justify-center">
          <!-- centered content -->
          <div
            class="p-4 bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
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
            Cette page permet de rechercher le numéro et de consulter le contenu
            associé en ligne.

            <br />
            {#await getMarksTotalCount}
              (Comptage des marquages en cours ... )
            {:then marksCounter}
              {#await getImprintsTotalCount}
                (Comptage des marquages en cours ... )
              {:then imprintsCounter}
                A ce jour, un total de <b> {BigInt(marksCounter)}</b> marquages
                uniques Sand Bless ont été gravés et référencés et
                <b> {BigInt(imprintsCounter)}</b> empreintes ont été ajoutées sur
                ces marquages.
              {/await}
            {/await}
          </div>
          <!-- end centered content -->
        </div>
      </div>
      <div class="w-full mb-4 px-2">
        <div class="flex items-center justify-center">
          <!-- centered content -->
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
                src="images/fully_on_chain-stripe-dark_text.svg"
                alt="100% on-chain"
              />
            </div>

            <form class="w-full">
              <div class="flex items-center border-b border-blue-500 py-2">
                <input
                  class="bg-transparent border border-gray-200 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
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
                    on:click={isMarkExist(inputCheckValue)}
                    class="flex-shrink-0 border-transparent cursor-pointer border-4 text-blue-500 hover:text-blue-800 text-sm py-1 px-2 rounded"
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
            <!-- end centered content -->
          </div>
        </div>
        <div class="w-full mb-4 px-2">
          {#if $auth.loggedIn}
            <div class="flex items-center justify-center">
              <!-- centered content -->
              <div
                class="p-6 bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
              >
                <a href="#">
                  <h5
                    class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                  >
                    Administration
                  </h5>
                </a>
                <p class="mb-3 font-normal text-gray-700 dark:text-gray-400" />

                <div class="grid grid-cols-1 divide-y">
                  <div class="py-4">
                    {#await $auth.actor.whoami()}
                      Querying caller identity...
                    {:then principalResult}
                      <div>Principal :</div>
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
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Marquage
                      </h5>
                      <button
                        class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                        on:click={createMark}>Creer un nouveau marquage</button
                      >
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Empreinte
                      </h5>

                      Selectioner le type d'empreinte :
                      <br />
                      <form class="w-full">
                        <select
                          class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                          bind:value={selectedImprintType}
                        >
                          {#each imprintTypeSelect as imprintType}
                            <option value={imprintType.id}>
                              {imprintType.text}
                            </option>
                          {/each}
                        </select>
                        <br />
                        Contenu de l'empreinte :
                        <br />
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

                        <div
                          class="flex items-center border-b border-blue-500 py-2"
                        >
                          <input
                            class="appearance-none bg-transparent border-none w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                            type="number"
                            bind:value={inputAddImprintValue}
                            placeholder="Numéro marquage"
                            aria-label="Numéro"
                            required
                          />

                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            on:click={() =>
                              addAssociatedMark(inputAddImprintValue)}
                            type="button"
                          >
                            Associer le marquage
                          </button>
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            on:click={resetinputsAssociatedMarks}
                            type="button"
                          >
                            Reinitialiser
                          </button>
                        </div>

                        Marquages à associer :
                        <br />

                        {#each $inputsAssociatedMarks as mark, index (index)}
                          <li>
                            index {index} : mark
                            {mark}
                          </li>
                        {/each}
                        {#if $inputsAssociatedMarks.length == 0}
                          Aucun marquage associé.
                        {/if}

                        <br />

                        <button
                          class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                          type="button"
                          on:click={createImprint(
                            inputAddImprintValue,
                            inputAddImprintTexteAreaValue
                          )}
                        >
                          Creer l'Empreinte
                        </button>
                      </form>
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Dev
                      </h5>

                      <button
                        class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                        type="button"
                        on:click={purgeCanister}
                      >
                        Purge Canister
                      </button>
                    </div>
                  </div>
                </div>
                <!-- end centered content -->
              </div>
            </div>
          {/if}
        </div>
        <div class="w-full mb-4 px-2">
          {#if currentMarkId}
            <div class="flex items-center justify-center">
              <!-- centered content -->
              <div
                class="p-6 bg-white border border-gray-200 rounded-lg shadow-md dark:bg-gray-800 dark:border-gray-700"
              >
                <a href="#">
                  <h5
                    class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                  >
                    Marquage numéro : {currentMarkId} <br />
                  </h5>
                </a>
                <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
                  Créé le {currentMarkCreatedWhen} <br />
                  {#if imprints.length > 0}
                    Tracé par
                    {imprints.length}
                    empreinte{#if imprints.length > 1}s{/if}
                  {:else}
                    Aucune empreinte.
                  {/if}
                </p>
              </div>
            </div>
          {/if}
        </div>
        <div class="w-full mb-4 px-2">
          {#if imprints.length > 0}
            <div class="overflow-x-auto relative">
              <table
                class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
              >
                <thead
                  class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
                >
                  <tr>
                    <th scope="col" class="py-3 px-6"> Empreinte </th>
                    <th scope="col" class="py-3 px-6"> Type </th>
                    <th scope="col" class="py-3 px-6"> Contenu </th>
                    <th scope="col" class="py-3 px-6">
                      Autres marquages associés</th
                    >
                  </tr>
                </thead>
                <tbody>
                  {#each imprints as imprint, index}
                    <tr
                      class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                    >
                      <td
                        scope="row"
                        class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                      >
                        {formatCanisterDate(imprint.createdWhen)}
                      </td>
                      <td class="py-4 px-6">
                        <ImprintType type={imprint.imprintType} />
                      </td>
                      <td class="py-4 px-6">
                        <ImprintData
                          data={imprint.imprintData}
                          type={imprint.imprintType}
                        />
                      </td>
                      <td class="py-4 px-6">
                        {#await $auth.actor.getMarkIdsByImprintId(BigInt(imprint.id)) then getMarkIdsByImprintIdResult}
                          {#each getMarkIdsByImprintIdResult as list, index (index)}
                            {#each list as id, index (index)}
                              {#if id != currentMarkId}
                                <div
                                  class="no-underline cursor-pointer hover:text-black hover:underline"
                                >
                                  <a on:click={isMarkExist(id)}>
                                    {id}
                                  </a>
                                </div>
                              {/if}
                            {/each}
                          {/each}
                        {/await}
                      </td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            </div>
          {/if}
        </div>
        <div class="w-full mb-4 px-2">
          {#if currentMarkId}
            <div class="flex items-center justify-center">
              <!-- centered content -->
              <a
                href="https://dfinity.org"
                target="_blank"
                rel="noopener noreferrer"
              >
                <img
                  src="images/ic-badge-powered-by-crypto_label-stripe-dark-text.svg"
                  alt="powered by crypto internet computer"
                />
              </a>
            </div>
          {/if}
        </div>
      </div>

      <!--
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
      {#each Array(getMarksTotalCountResult) as _, index (index)}
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
      {#each Array(getImprintsTotalCountResult) as _, index (index)}
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
          {index} :
          {#await $auth.actor.getImprintIdsByMarkId(BigInt(index)) then getImprintIdsByMarkIdResult}
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
          {index} :
          {#await $auth.actor.getMarkIdsByImprintId(BigInt(index)) then getMarkIdsByImprintIdResult}
            {getMarkIdsByImprintIdResult}
          {/await}
        </li>
      {/each}
    {/await}
    <br />
    -->
    </div>
  </section>
</div>
