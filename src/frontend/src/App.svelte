<script>
  import Footer from './components/Footer.svelte';
  import Menu from './components/Menu.svelte';

  import ServicesPage from './pages/ServicesPage.svelte';
  import MarksPage from './pages/MarksPage.svelte';

  import { TabGroup, TabPanel, TabPanels } from '@rgossiaux/svelte-headlessui';
</script>

<main>
  <div
    class="bg-white text-gray-600 myriad-pro-sans leading-normal text-base tracking-normal"
  >
    <TabGroup manual>
      <Menu />

      <TabPanels>
        <TabPanel>
          <ServicesPage />
        </TabPanel>
        <TabPanel>
          <MarksPage />
        </TabPanel>
      </TabPanels>
    </TabGroup>

    <Footer />
  </div>
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
