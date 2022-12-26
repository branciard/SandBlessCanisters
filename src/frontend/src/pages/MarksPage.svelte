<script>
  import CanisterIds from '../components/CanisterIds.svelte';
</script>

<div class="container mx-auto bg-white py-8 border-t border-gray-400">
  <section class="bg-white py-8">
    <div class="container flex px-3 py-8 ">
      <div class="w-full mx-auto flex flex-wrap content-center">
        <div class="flex w-full lg:w-1/2 ">
          <div class="px-3 md:px-0">
            <h1
              class="uppercase tracking-wide no-underline hover:no-underline font-bold text-gray-800 text-xl"
            >
              Registre des marquages Sand Bless bientot disponbile
            </h1>
          </div>
        </div>
      </div>
    </div>
    <br />
    Utilisation de la technologie Dfinity.
    <br />
    <br />
    <a href="https://dfinity.org" target="_blank" rel="noopener noreferrer">
      <img
        class="logoOnChain"
        src="images/100_on_chain-small-centered-dark_text.svg"
        alt="100% on-chain"
      />
    </a>
    <br />
    <CanisterIds />
    <br />
  </section>
</div>
