<script>
  import { onMount } from 'svelte';
  import QRCode from 'qrcode';
  export let tokenid;

  const baseUrl =
    'https://' + process.env.BACKEND_CANISTER_ID + '.app?tokenid=';
  const QRCodeText = baseUrl + tokenid;

  onMount(async () => {
    var canvas = document.getElementById('qrcode' + tokenid);
    QRCode.toCanvas(
      canvas,
      QRCodeText,
      { errorCorrectionLevel: 'H', scale: 3 },
      function (error) {
        if (error) console.error(error);
        console.log('success!');
      }
    );
  });
</script>

<div class="popupcontent">
  <p>Blessed Mark universal Link</p>
  <div>
    <a
      href={'https://' +
        process.env.BACKEND_CANISTER_ID +
        '.ic0.app?tokenid=' +
        tokenid}
      target="_blank"
      class="cursor-pointer"
      >{'https://' + process.env.BACKEND_CANISTER_ID + '.ic0.app'}</a
    >
  </div>
  <div>
    <p>
      Blessed mark Number :
      {tokenid}
    </p>
  </div>
  <p>Blessed Mark universal QR Code</p>
  <div>
    <canvas id="qrcode{tokenid}" class="qrcodeStyle" />
  </div>
</div>

<style>
  .qrcodeStyle {
    display: inline;
  }
  .popupcontent {
    align-content: center;
    padding: 6px 6px 6px 6px;
    background: repeating-radial-gradient(
      closest-side at 15px 25px,
      var(--color-wheat) 15%,
      var(--color-lightyellow) 40%
    );
  }
</style>
