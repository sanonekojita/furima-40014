function post (){
  const itemPrice  = document.getElementById("item-price");
  itemPrice.addEventListener("keyup", () => {
    const addTaxPrice  = document.getElementById("add-tax-price");
    const profit  = document.getElementById("profit");

    const TaxPrice = parseInt(itemPrice.value / 10);
    const Profit = itemPrice.value - TaxPrice
    const formattedTaxPrice = TaxPrice.toLocaleString();
    const formattedProfit = Profit.toLocaleString();


    addTaxPrice.innerHTML = `${formattedTaxPrice}`;
    profit.innerHTML = `${formattedProfit}`;
  });
};

window.addEventListener('turbo:load', post);