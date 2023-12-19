let payjpInstance = null;

const pay = () => {

  const form = document.getElementById('charge-form');

  if (form) {

    if (!payjpInstance) {
      const publicKey = gon.public_key;
      payjpInstance = Payjp(publicKey);
    }

    const elements = payjpInstance.elements();
    const numberElement = elements.create('cardNumber');
    const expiryElement = elements.create('cardExpiry');
    const cvcElement = elements.create('cardCvc');

    numberElement.mount('#number-form');
    expiryElement.mount('#expiry-form');
    cvcElement.mount('#cvc-form');
    
    form.addEventListener("submit", (e) => {
      payjpInstance.createToken(numberElement).then(function (response) {
        if (response.error) {
        } else {
          const token = response.id;
          const renderDom = document.getElementById("charge-form");
          const tokenObj = `<input value=${token} name='token' type="hidden">`;
          renderDom.insertAdjacentHTML("beforeend", tokenObj);
        }
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        document.getElementById("charge-form").submit();
      });

      e.preventDefault();
    });
  }
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
