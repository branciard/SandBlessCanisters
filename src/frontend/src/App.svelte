<script>
  import CanisterIds from './components/CanisterIds.svelte';
  import Howto from './components/Howto.svelte';
  import Blessings from './components/Blessings.svelte';
  import CheckBlessing from './components/CheckBlessing.svelte';
</script>

<main>
  <h1>Sand Bless Unction</h1>

  <a href="https://dfinity.org" target="_blank" rel="noopener noreferrer">
    <img
      class="logoOnChain"
      src="images/100_on_chain-small-centered-dark_text.svg"
      alt="100% on-chain"
    />
  </a>

  <h2>Bless your artwork using owned crypto-marks.</h2>

  <Howto />
  <Blessings />
  <CheckBlessing />

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
</main>

<style>
  img {
    height: 22px;
  }
  .logo {
    display: inline-block;
    margin-bottom: 5px;
    margin-top: 5px;
  }
  .logoOnChain {
    display: inline-block;
    margin-bottom: 5px;
    margin-top: 5px;
    height: 85px;
  }

  main {
    text-align: center;
    padding: 1em;
  }

  h1 {
    text-transform: uppercase;
    font-size: 3em;
    font-weight: 400;
    line-height: 1.09;
  }
  h2 {
    margin-bottom: 50px;
    margin-top: 25px;
  }

  @media (min-width: 640px) {
    main {
      max-width: 800px;
      margin: 0 auto;
    }
    h1 {
      font-size: 4em;
    }
  }
</style>
