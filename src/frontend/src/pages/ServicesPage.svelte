<script>
  import ImageIPFSGateway from '../components/ImageIPFSGateway.svelte';
</script>

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
          <h1 class="text-gray-900 text-xl leading-tight font-medium mb-2">
            Sablages et s&eacute;rigraphies
          </h1>

          <ul class=" text-gray-700 text-base mb-4 list-disc">
            <li>Cadeaux</li>
            <li>Souvenirs</li>
            <li>Logos</li>
            <li>Décorations</li>
            <li>Marquages uniques vérifiables...</li>
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
            >Commandez votre gravure</a
          >
        </div>
      </div>
    </div>
  </div>
</section>

<section class="bg-white py-8">
  <div class="container mx-auto flex items-center flex-wrap pt-4 pb-12">
    <nav id="store" class="w-full z-30 top-0 px-6 py-1">
      <div
        class="w-full container mx-auto flex flex-wrap items-center justify-between mt-0 px-2 py-3"
      >
        <a
          class="uppercase tracking-wide no-underline hover:no-underline font-bold text-gray-800 text-xl"
          href="#"
        >
          Tarification des services
        </a>

        <div class="flex items-center" id="store-nav-content" />
      </div>
    </nav>

    <div class="w-full md:w-1/3 xl:w-1/4 p-6 flex flex-col">
      <a
        href="mailto:contact@sandbless.fr?subject=Commande&nbsp;Gravure&nbsp;Simple"
      >
        <ImageIPFSGateway
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
          gateway="https://gateway.pinata.cloud/ipfs/"
          cid="QmSmLmZs6F5vycwWBk3NeCgHLnuYEzKpaFSFV7obLLzijQ"
        />
        <div class="pt-3 flex items-center justify-between">
          <p class="">Marquage unique vérifiable ( bientot disponible )</p>
        </div>
        <p class="pt-1 text-gray-900">9 € HT</p>
      </a>
    </div>
  </div>
</section>
