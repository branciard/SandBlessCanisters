<script>
  import { IMPRINT_TYPE_ENUM } from '../store/constants';
  export let type;

  if (type.includes('Comment')) {
    typeTranslated = IMPRINT_TYPE_ENUM.Comment;
  } else if (type.includes('PubJoke')) {
    typeTranslated = IMPRINT_TYPE_ENUM.PubJoke;
  } else if (type.includes('ImageIPFS')) {
    typeTranslated = IMPRINT_TYPE_ENUM.ImageIPFS;
  } else if (type.includes('SandblastingMark')) {
    typeTranslated = IMPRINT_TYPE_ENUM.SandblastingMark;
  } else {
    typeTranslated = type;
  }
</script>

{typeTranslated}
