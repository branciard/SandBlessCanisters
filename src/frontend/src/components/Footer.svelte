<script>
  import FaInstagram from 'svelte-icons/fa/FaInstagram.svelte';
  import FaRegEnvelope from 'svelte-icons/fa/FaRegEnvelope.svelte';
  import FaFacebookSquare from 'svelte-icons/fa/FaFacebookSquare.svelte';
</script>

<footer class="container mx-auto bg-white py-8 border-t border-gray-400">
  <div class="container flex px-3 py-8 ">
    <div class="w-full mx-auto flex flex-wrap">
      <div class="flex w-full lg:w-1/2 ">
        <div class="px-3 md:px-0">
          <h3 class="font-bold text-gray-900">A propos</h3>
          <p class="py-2">
            Artisan graveur, je personnalise verres, bouteilles, carafes,
            thermos ou autre objets, pour une mise en valeur de votre production
            viticole, bars, restaurants, évenements, mariages ou décorations.
          </p>
          <p class="py-2">
            Envoyez textes, logos, photos ou idées par e-mail et le support
            voulu. Je vous ferai un retour sur la faisabilité et une
            proposition. Production en serie possible sur devis.
          </p>
          <p class="py-2">
            Les gravures sont réalisées par projection de sable offrant une
            finition de qualité. Un film spécial permet de réaliser de fins
            détails pour transferer logos et photos. La coloration est possible
            par projection de peintures apres sablage.
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
    </div>
  </div>

  <div class="flex w-full items-stretch">
    <p class="py-18">
      FRANCOIS BRANCIARD - GRAVURE - CISELURE - APRM 2313ZC - APET 9003A - SIRET
      84862922600012 - TVA FR82848629226 - 136 RUE DE LA COMBE VINEUSE 71570
      PRUZILLY FRANCE
    </p>
  </div>
</footer>
