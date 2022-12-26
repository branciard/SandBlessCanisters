<script>
  import { Tab, TabList } from '@rgossiaux/svelte-headlessui';
  import FaInstagram from 'svelte-icons/fa/FaInstagram.svelte';
  import FaRegEnvelope from 'svelte-icons/fa/FaRegEnvelope.svelte';
  import FaFacebookSquare from 'svelte-icons/fa/FaFacebookSquare.svelte';
</script>

<!--Nav-->
<nav id="header" class="w-full z-30 top-0 py-1">
  <TabList>
    <div
      class="w-full container mx-auto flex flex-wrap items-center justify-between mt-0 px-6 py-3"
    >
      <div class="order-2 md:order-1">
        <a class=" flex items-center tracking-wide w-32" href="#">
          <img src="images/SandBlessLogo100x50px.png" alt="SandBless Logo" />
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
                  href="#">Sablages et s&eacute;rigraphies</a
                >
              </Tab>
            </li>
            <li>
              <Tab>
                <a
                  class="inline-block no-underline hover:text-black hover:underline py-2 px-4"
                  href="#"
                >
                  Registre des marquages</a
                >
              </Tab>
            </li>
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
