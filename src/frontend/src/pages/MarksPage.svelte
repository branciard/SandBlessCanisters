<script>
  import ImprintData from '../components/ImprintData.svelte';
  import ImprintType from '../components/ImprintType.svelte';

  import { AuthClient } from '@dfinity/auth-client';
  import { Principal } from '@dfinity/principal';
  import { auth, createActor } from '../store/auth';
  import { IMPRINT_TYPE_ENUM } from '../store/constants';
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';

  import { createBlob, blobToBinaryString, blobToArrayBuffer } from 'blob-util';
  import moment from 'moment';

  import 'moment/locale/fr';

  import { writable } from 'svelte/store';

  //https://v1.tailwindcss.com/components/forms

  let client;
  let checkOk = false;
  let checkKo = false;

  let newMarkCreated = false;
  let showNewMarkCreated = false;

  let newImprintCreated = false;
  let showNewImprintCreated = false;
  let newImprintCreatedError = null;

  // intpus froms
  let imprintTypeSelect = [
    { id: 1, text: IMPRINT_TYPE_ENUM[1] },
    { id: 2, text: IMPRINT_TYPE_ENUM[2] },
  ];

  let selectedImprintType = imprintTypeSelect[0].id;

  let inputCheckValue;

  let inputAssociateMarktoImprint;
  let inputAssociateMarktoImprintError = false;
  let inputAssociateMarktoImprintErrorMessage =
    'Le marquage a associer doit être un nombre';
  let inputImprintContent = ``;

  const inputsAssociatedMarks = writable([]);

  let inputVisibilityValue;

  let inputAddCustodianValue;
  let inputRemoveCustodianValue;

  function isNumeric(str) {
    if (typeof str != 'string') return false; // we only process strings!
    return (
      !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
      !isNaN(parseFloat(str))
    ); // ...and ensure strings of whitespace fail
  }

  //form validation https://svelte.dev/repl/5230b1d71f1b4b048cf05e3a7a49aefc?version=3.24.0
  const addAssociatedMark = (inputAssociateMarktoImprint) => {
    inputAssociateMarktoImprintError = false;
    if (isNumeric(JSON.stringify(inputAssociateMarktoImprint))) {
      $inputsAssociatedMarks = [
        ...$inputsAssociatedMarks,
        inputAssociateMarktoImprint,
      ];
    } else {
      inputAssociateMarktoImprintError = true;
    }
  };

  function resetinputsAssociatedMarks() {
    newImprintCreatedError = null;
    inputAssociateMarktoImprintError = false;
    $inputsAssociatedMarks = [];
  }

  let currentMarkId;
  let currentMarkCreatedWhen;
  let currentMarkCreatedBy;

  let imprints = [];
  let imprintsInvisbilesCount = 0;

  onMount(async () => {
    client = await AuthClient.create();
    if (await client.isAuthenticated()) {
      handleAuth();
      newMarkCreated = false;
      newImprintCreated = false;
      newImprintCreatedError = null;
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

  function formatCanisterFullDate(canisterDate) {
    return moment(Number(canisterDate.toString().substring(0, 13)))
      .locale('fr')
      .format('Do MMMM YYYY à HH:mm:ss');
  }

  function formatCanisterDateDay(canisterDate) {
    return moment(Number(canisterDate.toString().substring(0, 13)))
      .locale('fr')
      .format('Do MMMM YYYY');
  }

  function formatCanisterDateHours(canisterDate) {
    return moment(Number(canisterDate.toString().substring(0, 13)))
      .locale('fr')
      .format('HH:mm:ss');
  }

  async function logout() {
    await client.logout();
    auth.update(() => ({
      loggedIn: false,
      actor: createActor(),
    }));
  }

  function handleSubmitCreateMark(e) {
    showNewMarkCreated = true;
    setTimeout(function () {
      showNewMarkCreated = false;
    }, 8000);
  }

  function handleSubmitCreateImprint(e) {
    showNewImprintCreated = true;
    setTimeout(function () {
      showNewImprintCreated = false;
    }, 8000);
  }

  async function createMark() {
    if ($auth.loggedIn) {
      newMarkCreated = false;
      console.log('createMark call');
      let result = await $auth.actor.createMark();
      console.log('createMark result:');
      console.log(result);
      if (result.Ok) {
        console.log('OK :');
        try {
          const markId = BigInt(result.Ok.id);
          await getMarkAndloadPage(markId);
          newMarkCreated = true;
        } catch (e) {
          console.log(e);
          console.log('fail to get mark created');
        }
      }
    }
  }

  async function setImprintVisible() {
    if ($auth.loggedIn) {
      console.log('setImprintVisible call');
      let result = await $auth.actor.setImprintVisible(inputVisibilityValue);
      console.log('setImprintVisible result:');
      console.log(result);
    }
  }

  async function setImprintInvisible(inputVisibilityValue) {
    if ($auth.loggedIn) {
      console.log('setImprintInvisible call');
      let result = await $auth.actor.setImprintInvisible(inputVisibilityValue);
      console.log('setImprintInvisible result:');
      console.log(result);
    }
  }

  async function createImprint(selectedImprintType, inputImprintContent) {
    if ($auth.loggedIn) {
      newImprintCreated = false;
      newImprintCreatedError = null;
      console.log('createImprint call');

      let imprint = {
        TextContent: inputImprintContent,
      };

      let result = await $auth.actor.createImprint(
        $inputsAssociatedMarks,
        selectedImprintType,
        imprint
      );
      console.log('createImprint result:');
      console.log(result);
      if (result.Ok) {
        console.log('OK :');
        try {
          await getImprint(result.Ok.id);
          newImprintCreated = true;
        } catch (e) {
          console.log(e);
          console.log('fail to get imprint created');
          newImprintCreatedError = JSON.stringify(e);
        }
      } else {
        console.log('not OK');
        console.log(result);
        newImprintCreatedError = JSON.stringify(result.Err);
      }
    }
  }

  async function getImprint(imprintId) {
    console.log('getImprint:' + imprintId);
    if (imprintId) {
      const result = await $auth.actor.getImprint(BigInt(imprintId));
      console.log('get imprintId result :');
      if (result.Ok) {
        console.log('OK :');
        console.log(result);
        return result;
      } else {
        console.log('not OK');
        console.log(result);
      }
    }
  }

  async function getMarkAndloadPage(markId) {
    console.log('getMark:' + markId);
    if (markId) {
      const result = await $auth.actor.getMark(BigInt(markId));
      console.log('get mark result :');
      if (result.Ok) {
        console.log('OK :');
        console.log(result);
        currentMarkId = result.Ok.id;
        currentMarkCreatedWhen = formatCanisterFullDate(result.Ok.createdWhen);
        currentMarkCreatedBy = result.Ok.createdBy;
        await getImprintsByMarkId(markId);
        return result;
      } else {
        console.log('not OK');
        console.log(result);
      }
    }
  }

  async function getImprintsByMarkId(markId) {
    console.log('getImprintsByMarkId:' + markId);
    imprintsInvisbilesCount = 0;
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
            if (imprintsResult.Ok.visible == false) {
              imprintsInvisbilesCount = imprintsInvisbilesCount + 1;
            }
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

  async function addCustodian(inputAddCustodianValue) {
    if ($auth.loggedIn) {
      console.log('addCustodian');
      let result = await $auth.actor.addCustodian(inputAddCustodianValue);
      console.log('addCustodian result');
      console.log(result);
    }
  }

  async function removeCustodian(inputRemoveCustodianValue) {
    if ($auth.loggedIn) {
      console.log('removeCustodian');
      let result = await $auth.actor.removeCustodian(inputRemoveCustodianValue);
      console.log('removeCustodian result');
      console.log(result);
    }
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
        await getMarkAndloadPage(markId);
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
            A ce jour, un total de
            <b>
              {#await $auth.actor.getMarksTotalCount() then totalMarks}
                {totalMarks}
              {/await}
            </b>
            marquages uniques Sand Bless ont été gravés et référencés et
            <b>
              {#await $auth.actor.getImprintsTotalCount() then totalImprints}
                {totalImprints}
              {/await}
            </b> empreintes ont été ajoutées. sur ces marquages.
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
              <!-- svelte-ignore a11y-click-events-have-key-events -->
              <img
                on:click={login}
                src="images/fully_on_chain-stripe-dark_text.svg"
                alt="100% on-chain"
              />
            </div>

            <a
              class="bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
              href="mailto:contact@sandbless.fr?subject=Commandez&nbsp;un&nbsp;marquage"
              target="_blank">Commandez un marquage</a
            >

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
                    {#await $auth.actor.whoamiTextformat()}
                      Querying caller identity...
                    {:then principalResult}
                      <div>Principal :</div>
                      <div>
                        <code>{principalResult}</code>
                        <br />
                        Administrateur :

                        {#await $auth.actor.isCustodian(principalResult) then isPrincipalCustodianResult2}
                          {isPrincipalCustodianResult2}
                        {/await}
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
                      <form
                        id="creatMarkForm"
                        class="mt-4"
                        on:submit|preventDefault={handleSubmitCreateMark}
                      >
                        <button
                          class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                          type="submit"
                          on:click={createMark}
                          >Creer un nouveau marquage</button
                        >
                        {#if newMarkCreated && showNewMarkCreated}
                          <span
                            class="success-alert"
                            transition:fade={{ duration: 150 }}
                          >
                            Nouveau marquage numéro {#await $auth.actor.getMarksTotalCount() then totalMarks}
                              {totalMarks}
                            {/await} créé !
                          </span>
                        {/if}
                      </form>
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Empreinte
                      </h5>

                      Selectioner le type d'empreinte :
                      <br />
                      <form
                        id="creatImprintForm"
                        class="w-full"
                        on:submit|preventDefault={handleSubmitCreateImprint}
                      >
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
                          bind:value={inputImprintContent}
                        />

                        <div
                          class="flex items-center border-b border-blue-500 py-2"
                        >
                          <input
                            class="bg-transparent border border-gray-200 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                            type="number"
                            bind:value={inputAssociateMarktoImprint}
                            placeholder="Numéro marquage"
                            aria-label="Numéro"
                            required
                          />

                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            on:click={() =>
                              addAssociatedMark(inputAssociateMarktoImprint)}
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

                        {inputAssociateMarktoImprintError
                          ? inputAssociateMarktoImprintErrorMessage
                          : ''}

                        <br />

                        {#each $inputsAssociatedMarks as mark, index (index)}
                          <li>
                            associer marque
                            {mark}
                          </li>
                        {/each}
                        {#if $inputsAssociatedMarks.length == 0}
                          <span class="text-red-700"
                            >Aucun marquage associé.</span
                          >
                        {/if}

                        <br />
                        {#if !inputImprintContent}
                          <span class="text-red-700"
                            >Contenu de l'empreinte est vide</span
                          >
                          <br />
                        {/if}

                        <span class="text-red-700">
                          {inputAssociateMarktoImprintError
                            ? inputAssociateMarktoImprintErrorMessage
                            : ''}
                        </span>

                        {#if inputImprintContent && $inputsAssociatedMarks.length > 0}
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            type="submit"
                            on:click={createImprint(
                              selectedImprintType,
                              inputImprintContent
                            )}
                          >
                            Creer l'Empreinte
                          </button>
                        {/if}
                        {#if newImprintCreated && showNewImprintCreated}
                          <span
                            class="success-alert"
                            transition:fade={{ duration: 150 }}
                          >
                            Nouvelle empreinte numéro {#await $auth.actor.getImprintsTotalCount() then totalImprints}
                              {totalImprints}
                            {/await} créée sur le(s) marquages {$inputsAssociatedMarks}
                            !
                          </span>
                        {/if}
                        {#if newImprintCreatedError}
                          <span class="text-red-700">
                            {newImprintCreatedError}
                          </span>
                        {/if}
                      </form>
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Visibilité Emptreinte
                      </h5>

                      <form class="w-full">
                        <div
                          class="flex items-center border-b border-blue-500 py-2"
                        >
                          <input
                            class="bg-transparent border border-gray-200 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                            type="number"
                            bind:value={inputVisibilityValue}
                            placeholder="Numéro"
                            aria-label="Numéro"
                            required
                          />
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            type="button"
                            on:click={setImprintVisible(inputVisibilityValue)}
                          >
                            Forcer à visible
                          </button>
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            type="button"
                            on:click={setImprintInvisible(inputVisibilityValue)}
                          >
                            Forcer à invisible
                          </button>
                        </div>
                      </form>
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        {#await $auth.actor.getCustodiansTreeSize() then getCustodiansTreeSizeResult}
                          {getCustodiansTreeSizeResult}
                        {/await} Administrateurs
                      </h5>

                      {#await $auth.actor.getCustodians() then getCustodiansResult}
                        {#each getCustodiansResult as custodian}
                          <br />
                          {custodian.toString().split(',')[0]}
                        {/each}
                      {/await}
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Ajout Administrateur
                      </h5>

                      <form class="w-full">
                        <div
                          class="flex items-center border-b border-blue-500 py-2"
                        >
                          <input
                            class="bg-transparent border border-gray-200 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                            bind:value={inputAddCustodianValue}
                            placeholder="Principal"
                            required
                          />
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            type="button"
                            on:click={addCustodian(inputAddCustodianValue)}
                          >
                            Ajouter
                          </button>
                        </div>
                      </form>
                    </div>

                    <div class="py-4">
                      <h5
                        class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"
                      >
                        Retirer Administrateur
                      </h5>

                      <form class="w-full">
                        <div
                          class="flex items-center border-b border-blue-500 py-2"
                        >
                          <input
                            class="bg-transparent border border-gray-200 w-full text-gray-700 mr-3 py-1 px-2 leading-tight focus:outline-none"
                            bind:value={inputRemoveCustodianValue}
                            placeholder="Principal"
                            aria-label="Numéro"
                            required
                          />
                          <button
                            class="flex-shrink-0 bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                            type="button"
                            on:click={removeCustodian(
                              inputRemoveCustodianValue
                            )}
                          >
                            Retirer
                          </button>
                        </div>
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
                    Marquage numéro: {currentMarkId} <br />
                  </h5>
                </a>
                <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
                  Créé le {currentMarkCreatedWhen} <br />
                  {#if imprints.length > 0}
                    Tracé par
                    {imprints.length}
                    empreinte{#if imprints.length > 1}s{/if}
                    {#if imprintsInvisbilesCount > 0}
                      ( dont {imprintsInvisbilesCount} empreinte{#if imprintsInvisbilesCount > 1}s{/if}
                      {#if imprintsInvisbilesCount > 1}sont {:else} est{/if} masquée{#if imprintsInvisbilesCount > 1}s{/if}
                      ou archivée{#if imprintsInvisbilesCount > 1}s{/if} )
                    {/if}
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
                    <th scope="col" class="py-3 px-6"> Contenue </th>
                    <th scope="col" class="py-3 px-6">
                      Autres marquages associés</th
                    >
                  </tr>
                </thead>
                <tbody>
                  {#each imprints as imprint, index}
                    {#if imprint.visible}
                      <tr
                        class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                      >
                        <td
                          scope="row"
                          class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                        >
                          <div class="text-gray-700 text-xs">
                            Empreinte id {imprint.id}
                          </div>
                          Le {formatCanisterDateDay(imprint.createdWhen)}
                          <br />
                          à {formatCanisterDateHours(imprint.createdWhen)}
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
                    {/if}
                  {/each}
                  <tr
                    class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                  >
                    <td
                      scope="row"
                      class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                    >
                      <a
                        class="bg-blue-500 hover:bg-blue-700 border-blue-500 hover:border-blue-700 text-sm border-4 text-white py-1 px-2 rounded"
                        href="mailto:contact@sandbless.fr?subject=Proposez&nbsp;une&nbsp;empreinte&nbsp;marque&nbsp;{currentMarkId}"
                        target="_blank"
                        rel="noreferrer">Proposez une empreinte</a
                      >
                    </td>
                    <td class="py-4 px-6" />
                    <td class="py-4 px-6" />
                    <td class="py-4 px-6" />
                  </tr>
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
      {#await $auth.actor.getMarksTreeSize() then getMarksTreeSizeResult}
        {getMarksTreeSizeResult}
      {/await}
      <br />
      getMarksTotalCount:
      {#await $auth.actor.getMarksTotalCount() then getMarksTotalCountResult}
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
      {#await $auth.actor.getImprintsTreeSize() then getImprintsTreeSizeResult}
        {getImprintsTreeSizeResult}
      {/await}
      <br />
      getImprintsTotalCount:
      {#await $auth.actor.getImprintsTotalCount() then getImprintsTotalCountResult}
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
      {#await $auth.actor.getImprintIdsByMarkIdTreeSize() then getImprintIdsByMarkIdTreeSizeResult}
        {getImprintIdsByMarkIdTreeSizeResult}
        getImprintIdsByMarkIdTree:
        {#await $auth.actor.getImprintIdsByMarkIdTree() then getImprintIdsByMarkIdTreeResult}
          {getImprintIdsByMarkIdTreeResult}
        {/await}
      {/await}
      <br />
      getMarkIdsByImprintIdTreeSize :
      {#await $auth.actor.getMarkIdsByImprintIdTreeSize() then getMarkIdsByImprintIdTreeSizeResult}
        {getMarkIdsByImprintIdTreeSizeResult}

        getMarkIdsByImprintIdTree:
        {#await $auth.actor.getMarkIdsByImprintIdTree() then getMarkIdsByImprintIdTreeResult}
          {getMarkIdsByImprintIdTreeResult}
        {/await}
      {/await}
      <br />
      -->
    </div>
  </section>
</div>

<style>
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
