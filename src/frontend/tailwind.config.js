const production = !process.env.ROLLUP_WATCH; 
module.exports = {
  theme: {
    fontFamily: {
      sans: ['myriad-pro', 'sans-serif']
    }
  },
  future: { 
    purgeLayersByDefault: true, 
    removeDeprecatedGapUtilities: true,
  },
  plugins: [

  ],
  purge: {
    content: [
      "./src/**/*.svelte",
      
    ], 
    enabled: production // disable purge in dev
  },
};