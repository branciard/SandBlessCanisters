<script>
  import { onMount, setContext } from 'svelte';
  import CanisterIds from './components/CanisterIds.svelte';
  import Howto from './components/Howto.svelte';
  import Blessings from './components/Blessings.svelte';
  import CheckBlessing from './components/CheckBlessing.svelte';

  import ImageIPFSGateway from './components/ImageIPFSGateway.svelte';

  import { ipfs } from './store/ipfs';

  import {
    Tab,
    TabGroup,
    TabList,
    TabPanel,
    TabPanels,
  } from '@rgossiaux/svelte-headlessui';

  const promiseIPFSInstance = ipfs.get();
</script>

<main>
  {#await promiseIPFSInstance}
    <img
      class="hover:grow hover:shadow-lg"
      src="https://c.tenor.com/On7kvXhzml4AAAAi/loading-gif.gif"
      alt="Fetching IPFS data......"
    />
  {:then ipfs}
    <div
      class="bg-white text-gray-600 work-sans leading-normal text-base tracking-normal"
    >
      <TabGroup manual>
        <!--Nav-->
        <nav id="header" class="w-full z-30 top-0 py-1">
          <TabList>
            <div
              class="w-full container mx-auto flex flex-wrap items-center justify-between mt-0 px-6 py-3"
            >
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
                class="hidden md:flex md:items-center md:w-auto w-full order-3 md:order-1"
                id="menu"
              >
                <nav>
                  <ul
                    class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0"
                  >
                    <li>
                      <Tab>
                        <a
                          class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                          href="#">Atelier Gravure</a
                        >
                      </Tab>
                    </li>
                    <li>
                      <Tab>
                        <a
                          class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                          href="#">Crypto Marks</a
                        >
                      </Tab>
                    </li>
                  </ul>
                </nav>
              </div>

              <div class="order-1 md:order-2">
                <a
                  class="flex items-center tracking-wide no-underline hover:no-underline font-bold text-gray-800 text-xl "
                  href="#"
                >
                  <svg
                    class="fill-current text-gray-800 mr-2"
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M5,22h14c1.103,0,2-0.897,2-2V9c0-0.553-0.447-1-1-1h-3V7c0-2.757-2.243-5-5-5S7,4.243,7,7v1H4C3.447,8,3,8.447,3,9v11 C3,21.103,3.897,22,5,22z M9,7c0-1.654,1.346-3,3-3s3,1.346,3,3v1H9V7z M5,10h2v2h2v-2h6v2h2v-2h2l0.002,10H5V10z"
                    />
                  </svg>
                  SAND BLESS
                </a>
              </div>

              <div
                class="order-2 md:order-3 flex items-center"
                id="nav-content"
              >
                <nav>
                  <ul
                    class="md:flex items-center justify-between text-base text-gray-700 pt-4 md:pt-0"
                  >
                    <li>
                      <a
                        class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                        href="mailto:francoisbranciard@gmail.com">Contact</a
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
              <div class="container mx-auto">
                <div
                  class="flex flex-col w-full lg:w-1/2 justify-center items-start  px-6 tracking-wide"
                >
                  <h1 class="text-black text-2xl my-4">
                    <div>SAND BLESS,</div>
                    <div>Un sablage artisanal,</div>
                    <div>unique et personalis&eacute;.</div>

                    <br />
                    <div>Créations, logos, souvenirs,</div>
                    <div>anniversaires, mariages...</div>
                    <br />
                    <div>Gravures sur verres, carafes,</div>
                    <div>bouteilles de vin, thermos...</div>
                    <br />
                  </h1>
                  <a
                    class="text-xl inline-block no-underline border-b border-gray-600 leading-relaxed hover:text-black hover:border-black"
                    href="#">Commander votre gravure</a
                  >
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
                      Gravures personnalisés
                    </a>

                    <div class="flex items-center" id="store-nav-content">
                      <a
                        class="pl-3 inline-block no-underline hover:text-black"
                        href="#"
                      >
                        <svg
                          class="fill-current hover:text-black"
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                        >
                          <path
                            d="M7 11H17V13H7zM4 7H20V9H4zM10 15H14V17H10z"
                          />
                        </svg>
                      </a>

                      <a
                        class="pl-3 inline-block no-underline hover:text-black"
                        href="#"
                      >
                        <svg
                          class="fill-current hover:text-black"
                          xmlns="http://www.w3.org/2000/svg"
                          width="24"
                          height="24"
                          viewBox="0 0 24 24"
                        >
                          <path
                            d="M10,18c1.846,0,3.543-0.635,4.897-1.688l4.396,4.396l1.414-1.414l-4.396-4.396C17.365,13.543,18,11.846,18,10 c0-4.411-3.589-8-8-8s-8,3.589-8,8S5.589,18,10,18z M10,4c3.309,0,6,2.691,6,6s-2.691,6-6,6s-6-2.691-6-6S6.691,4,10,4z"
                          />
                        </svg>
                      </a>
                    </div>
                  </div>
                </nav>

                <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                  <a href="#">
                    <ImageIPFSGateway
                      {ipfs}
                      gateway="https://gateway.pinata.cloud/ipfs/"
                      cid="QmUkmxC4Ciz53g7b6oZY17ZejT1Q6VdgjR7pp2caDWSoR3"
                    />
                    <div class="pt-3 flex items-center justify-between">
                      <p class="">Sablage simple</p>
                    </div>
                    <p class="pt-1 text-gray-900">7 € HT</p>
                  </a>
                </div>

                <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                  <a href="#">
                    <ImageIPFSGateway
                      {ipfs}
                      gateway="https://gateway.pinata.cloud/ipfs/"
                      cid="QmfYrJJi6NsfwLZBcjDuHw9985MBg6vVfyWHSjMddGRf8p"
                    />
                    <div class="pt-3 flex items-center justify-between">
                      <p class="">Sablage avancé</p>
                    </div>
                    <p class="pt-1 text-gray-900">12 € HT</p>
                  </a>
                </div>

                <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                  <a href="#">
                    <ImageIPFSGateway
                      {ipfs}
                      gateway="https://gateway.pinata.cloud/ipfs/"
                      cid="QmTfuydnvx5k4gMdE9UnNyAMaJeqqt1bb7UA6XFhuabkQX"
                    />
                    <div class="pt-3 flex items-center justify-between">
                      <p class="">Sablage avancé + peinture</p>
                    </div>
                    <p class="pt-1 text-gray-900">18 € HT</p>
                  </a>
                </div>
                <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
                  <a href="#">
                    <ImageIPFSGateway
                      {ipfs}
                      gateway="https://gateway.pinata.cloud/ipfs/"
                      cid="QmVs6yJfqYJBwkycJGQmPH6pGKYvYfb7xbuSHdNPwQienB"
                    />
                    <div class="pt-3 flex items-center justify-between">
                      <p class="">Crypto Mark</p>
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
                  quisque non tellus orci ac auctor augue mauris. Accumsan lacus
                  vel facilisis volutpat est velit egestas dui id. At tempor commodo
                  ullamcorper a. Volutpat commodo sed egestas egestas fringilla.
                  Vitae congue eu consequat ac.
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
                <h3 class="font-bold text-gray-900">About</h3>
                <p class="py-4">
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit.
                  Maecenas vel mi ut felis tempus commodo nec id erat.
                  Suspendisse consectetur dapibus velit ut lacinia.
                </p>
              </div>
            </div>

            <div class="flex w-full lg:w-1/2 lg:justify-end lg:text-right">
              <div class="px-3 md:px-0">
                <h3 class="font-bold text-gray-900">Social</h3>
                <ul class="list-reset items-center pt-3">
                  <li>
                    <a
                      class="inline-block no-underline hover:text-black hover:underline py-1"
                      href="#">Add social links</a
                    >
                  </li>
                </ul>
              </div>
            </div>
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
          </div>
        </div>
      </footer>
    </div>
  {:catch error}
    <!-- promise was rejected -->
    <p>Error loading IPFS Instance: {error}</p>
  {/await}
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
