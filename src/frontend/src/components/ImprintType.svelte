<script>
  import { IMPRINT_TYPE_ENUM } from '../store/constants';
  export let type;
  let imprintTypeTranslated = 'Type Inconnu';

  for (let key in IMPRINT_TYPE_ENUM) {
    console.log(key);
    if (key && type && BigInt(key) == BigInt(type)) {
      imprintTypeTranslated = IMPRINT_TYPE_ENUM[key];
      break;
    }
  }
</script>

{imprintTypeTranslated}
