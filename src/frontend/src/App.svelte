<script>
  import { onMount, setContext } from 'svelte';
  import CanisterIds from './components/CanisterIds.svelte';
  import Howto from './components/Howto.svelte';
  import Blessings from './components/Blessings.svelte';
  import CheckBlessing from './components/CheckBlessing.svelte';

  import ImageIPFSGateway from './components/ImageIPFSGateway.svelte';
  import FaInstagram from 'svelte-icons/fa/FaInstagram.svelte';
  import FaRegEnvelope from 'svelte-icons/fa/FaRegEnvelope.svelte';
  import FaFacebookSquare from 'svelte-icons/fa/FaFacebookSquare.svelte';

  //import { ipfs } from './store/ipfs';

  const ipfs = null;

  import {
    Tab,
    TabGroup,
    TabList,
    TabPanel,
    TabPanels,
  } from '@rgossiaux/svelte-headlessui';

  //  const promiseIPFSInstance = ipfs.get();
</script>

<main>
  <!-- {#await promiseIPFSInstance}
    <div class="flex h-screen">
      <div class="m-auto">
        <img
          class="hover:grow hover:shadow-lg"
          src="images/SandBlessLoading.gif"
          alt="Fetching IPFS data......"
        />
      </div>
    </div>
  {:then ipfs}
  -->
  <div
    class="bg-white text-gray-600 myriad-pro-sans leading-normal text-base tracking-normal"
  >
    <TabGroup manual>
      <!--Nav-->
      <nav id="header" class="w-full z-30 top-0 py-1">
        <TabList>
          <div
            class="w-full container mx-auto flex flex-wrap items-center justify-between mt-0 px-6 py-3"
          >
            <div class="order-2 md:order-1">
              <a class=" flex items-center tracking-wide w-32" href="#">
                <img
                  src="images/SandBlessLogo100x50px.png"
                  alt="SandBless Logo"
                />
              </a>
            </div>

            <label for="menu-toggle" class="cursor-pointer md:hidden block">
              <svg
                class="fill-current text-gray-900"
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 20 20"
              >
                <title>menu</title>
                <path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z" />
              </svg>
            </label>
            <input class="hidden" type="checkbox" id="menu-toggle" />

            <div
              class="hidden md:flex md:items-center md:w-auto w-full order-3 md:order-2"
              id="menu"
            >
              <nav>
                <ul
                  class="md:flex items-center justify-between text-xl text-gray-700 pt-4 md:pt-0"
                >
                  <li>
                    <Tab>
                      <a
                        class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                        href="#">Gravures personnalis&eacute;es</a
                      >
                    </Tab>
                  </li>
                  <!--
                    <li>
                      <Tab>
                        <a
                          class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                          href="#">Artisanats</a
                        >
                      </Tab>
                    </li>
                    <li>
                      <Tab>
                        <a
                          class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                          href="#"
                        >
                          Marquage unique vérifiable</a
                        >
                      </Tab>
                    </li>
                  -->
                </ul>
              </nav>
            </div>

            <div class="order-2 md:order-3 flex items-center" id="nav-content">
              <nav>
                <ul
                  class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0"
                >
                  <li>
                    <a
                      class="inline-block w-7 mx-1"
                      href="mailto:contact@sandbless.fr"><FaRegEnvelope /></a
                    >
                  </li>
                  <li>
                    <a
                      class="inline-block w-7 mx-1"
                      target="_blank"
                      rel="noreferrer"
                      href="https://www.instagram.com/sandblessartisan/"
                    >
                      <FaInstagram /></a
                    >
                  </li>
                  <li>
                    <a
                      class="inline-block w-7 mx-1"
                      target="_blank"
                      rel="noreferrer"
                      href="https://www.facebook.com/sandblessartisan"
                    >
                      <FaFacebookSquare /></a
                    >
                  </li>
                </ul>
              </nav>
            </div>
          </div>
        </TabList>
      </nav>

      <TabPanels>
        <TabPanel>
          <section
            class="w-full mx-auto bg-nordic-gray-light flex pt-12 md:pt-0 md:items-center bg-cover bg-right"
            style="max-width:1600px; height: 32rem; background-image: url('images/sandblessbackground.gif');"
          >
            <div class="container mx-auto justify-center">
              <div
                class="flex flex-col w-full lg:w-1/2 justify-center items-start  px-6 tracking-wide"
              >
                <div class="flex justify-center">
                  <div class="block p-6 rounded-lg shadow-lg bg-white max-w-sm">
                    <h5
                      class="text-gray-900 text-xl leading-tight font-medium mb-2"
                    >
                      Gravures par micro-sablage.
                    </h5>

                    <ul class=" text-gray-700 text-base mb-4 list-disc">
                      <li>Cadeaux</li>
                      <li>Souvenirs</li>
                      <li>Logos</li>
                      <li>Décorations</li>
                      <li>Marquages ...</li>
                    </ul>

                    <ul class=" text-gray-700 text-base mb-4 list-disc">
                      Sur vos supports :
                      <li>Verres</li>
                      <li>Bouteilles</li>
                      <li>Carafes</li>
                      <li>Thermos...</li>
                    </ul>

                    <a
                      class="inline-block px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
                      href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure"
                      >Commander votre gravure</a
                    >
                  </div>
                </div>
              </div>
            </div>
          </section>

          <section class="bg-white py-8">
            <div
              class="container mx-auto flex items-center flex-wrap pt-4 pb-12"
            >
              <nav id="store" class="w-full z-30 top-0 px-6 py-1">
                <div
                  class="w-full container mx-auto flex flex-wrap items-center justify-between mt-0 px-2 py-3"
                >
                  <a
                    class="uppercase tracking-wide no-underline hover:no-underline font-bold text-gray-800 text-xl "
                    href="#"
                  >
                    Gravures personnalis&eacute;es
                  </a>

                  <div class="flex items-center" id="store-nav-content" />
                </div>
              </nav>

              <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                <a
                  href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure&nbsp;Simple"
                >
                  <ImageIPFSGateway
                    ipfs={ipfs ? null : null}
                    gateway="https://gateway.pinata.cloud/ipfs/"
                    cid="QmUkmxC4Ciz53g7b6oZY17ZejT1Q6VdgjR7pp2caDWSoR3"
                  />
                  <div class="pt-3 flex items-center justify-between">
                    <p class="">Sablage simple (ex : texte)</p>
                  </div>
                  <p class="pt-1 text-gray-900">7 € HT</p>
                </a>
              </div>

              <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                <a
                  href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure&nbsp;avanc&eacute;e"
                >
                  <ImageIPFSGateway
                    ipfs={ipfs ? null : null}
                    gateway="https://gateway.pinata.cloud/ipfs/"
                    cid="QmfYrJJi6NsfwLZBcjDuHw9985MBg6vVfyWHSjMddGRf8p"
                  />
                  <div class="pt-3 flex items-center justify-between">
                    <p class="">Sablage avanc&eacute; ( ex : logo, photo)</p>
                  </div>
                  <p class="pt-1 text-gray-900">12 € HT</p>
                </a>
              </div>

              <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                <a
                  href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure&nbsp;avanc&eacute;e&nbsp;avec&nbsp;peinture"
                >
                  <ImageIPFSGateway
                    ipfs={ipfs ? null : null}
                    gateway="https://gateway.pinata.cloud/ipfs/"
                    cid="QmYcmPhvGkJttm7GdUVe7nmSSKzrkZZ3BtxtpzgRo81P1t"
                  />
                  <div class="pt-3 flex items-center justify-between">
                    <p class="">Sablage avancé et sérigraphie couleur</p>
                  </div>
                  <p class="pt-1 text-gray-900">18 € HT</p>
                </a>
              </div>
              <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                <a
                  href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure&nbsp;SAND&nbsp;BLESS&nbsp;ID"
                >
                  <ImageIPFSGateway
                    ipfs={ipfs ? null : null}
                    gateway="https://gateway.pinata.cloud/ipfs/"
                    cid="QmSmLmZs6F5vycwWBk3NeCgHLnuYEzKpaFSFV7obLLzijQ"
                  />
                  <div class="pt-3 flex items-center justify-between">
                    <p class="">
                      Marquage unique vérifiable ( bientot disponible )
                    </p>
                  </div>
                  <p class="pt-1 text-gray-900">9 € HT</p>
                </a>
              </div>
            </div>
          </section>
        </TabPanel>
        <TabPanel>
          <section class="bg-white py-8">
            <div class="container py-8 px-6 mx-auto">
              <a
                class="uppercase tracking-wide no-underline hover:no-underline font-bold text-gray-800 text-xl mb-8"
                href="#"
              >
                About
              </a>

              <p class="mt-8 mb-8">
                This template is inspired by the stunning nordic minamalist
                design - in particular:
                <br />
                <a
                  class="text-gray-800 underline hover:text-gray-900"
                  href="http://savoy.nordicmade.com/"
                  target="_blank">Savoy Theme</a
                >
                created by
                <a
                  class="text-gray-800 underline hover:text-gray-900"
                  href="https://nordicmade.com/">https://nordicmade.com/</a
                >
                and
                <a
                  class="text-gray-800 underline hover:text-gray-900"
                  href="https://www.metricdesign.no/"
                  target="_blank">https://www.metricdesign.no/</a
                >
              </p>

              <p class="mb-8">
                Lorem ipsum dolor sit amet, consectetur <a href="#"
                  >random link</a
                > adipiscing elit, sed do eiusmod tempor incididunt ut labore et
                dolore magna aliqua. Vel risus commodo viverra maecenas accumsan
                lacus vel facilisis volutpat. Vitae aliquet nec ullamcorper sit.
                Nullam eget felis eget nunc lobortis mattis aliquam. In est ante
                in nibh mauris. Egestas congue quisque egestas diam in. Facilisi
                nullam vehicula ipsum a arcu. Nec nam aliquam sem et tortor consequat.
                Eget mi proin sed libero enim sed faucibus turpis in. Hac habitasse
                platea dictumst quisque. In aliquam sem fringilla ut. Gravida rutrum
                quisque non tellus orci ac auctor augue mauris. Accumsan lacus vel
                facilisis volutpat est velit egestas dui id. At tempor commodo ullamcorper
                a. Volutpat commodo sed egestas egestas fringilla. Vitae congue eu
                consequat ac.
              </p>
            </div>
          </section>

          <h1>Sand Bless Unction</h1>

          <h2>
            WORK PROGRESS !!!!! DO NOT USE Bless your artwork using owned
            crypto-marks.
          </h2>

          <h1 class="text-3xl font-bold underline">Hello world!</h1>

          <Howto />
          <Blessings />
          <CheckBlessing />

          <a
            href="https://dfinity.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            <img
              class="logoOnChain"
              src="images/100_on_chain-small-centered-dark_text.svg"
              alt="100% on-chain"
            />
          </a>
        </TabPanel>
      </TabPanels>
    </TabGroup>

    <footer class="container mx-auto bg-white py-8 border-t border-gray-400">
      <div class="container flex px-3 py-8 ">
        <div class="w-full mx-auto flex flex-wrap">
          <div class="flex w-full lg:w-1/2 ">
            <div class="px-3 md:px-0">
              <h3 class="font-bold text-gray-900">A propos</h3>
              <p class="py-2">
                Je personnalise verres, bouteilles, carafes, thermos ou autre
                objets, pour une mise en valeur de votre production viticole,
                bars, restaurants, évenements, mariages ou décorations.
              </p>
              <p class="py-2">
                Envoyez textes, logos, photos ou idées par e-mail et le support
                voulu. Je vous ferai un retour sur la faisabilité et une
                proposition. Production en serie possible sur devis.
              </p>
              <p class="py-2">
                Les gravures sont réalisées par projection de sable offrant une
                finition de qualité. Un film spécial permet de réaliser de fins
                détails pour transferer logos et photos. La coloration est
                possible par projection de peintures apres sablage.
              </p>
            </div>
          </div>

          <div class="flex w-full lg:w-1/2 lg:justify-end lg:text-right">
            <div class="px-3 md:px-0">
              <h3 class="font-bold text-gray-900">Social</h3>
              <ul
                class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0"
              >
                <li>
                  <a
                    class="inline-block w-7 mx-1"
                    href="mailto:contact@sandbless.fr"><FaRegEnvelope /></a
                  >
                </li>
                <li>
                  <a
                    class="inline-block w-7 mx-1"
                    target="_blank"
                    rel="noreferrer"
                    href="https://www.instagram.com/sandblessartisan/"
                  >
                    <FaInstagram /></a
                  >
                </li>
                <li>
                  <a
                    class="inline-block w-7 mx-1"
                    target="_blank"
                    rel="noreferrer"
                    href="https://www.facebook.com/sandblessartisan"
                  >
                    <FaFacebookSquare /></a
                  >
                </li>
              </ul>
            </div>
          </div>

          <!--
            <div class="flex w-full lg:w-1/2 lg:justify-end lg:text-right">
              <p>
                <a
                  href="https://dfinity.org"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="logo"
                >
                  <img
                    src="images/ic-badge-powered-by-crypto_label-stripe-dark-text.svg"
                    alt="Power by crypto internet computer"
                  />
                </a>
              </p>

              <CanisterIds />
            </div>
             -->
        </div>
      </div>
      <div class="flex w-full items-stretch">
        <p class="py-12">
          FRANCOIS BRANCIARD - GRAVURE - CISELURE - APRM 2313ZC - APET 9003A -
          SIRET 84862922600012 - TVA FR82848629226 - 136 RUE DE LA COMBE VINEUSE
          71570 PRUZILLY FRANCE
        </p>
      </div>
    </footer>
  </div>
  <!--  {:catch error}
    
    <p>Error loading IPFS Instance: {error}</p>
  {/await} 
-->
</main>

<style global lang="postcss">
  @tailwind base;
  @tailwind components;
  /* purgecss end ignore */
  @tailwind utilities;
  @layer utilities {
    .ml-55 {
      margin-left: 55%;
    }
  }
</style>
