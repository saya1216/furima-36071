function post (){
  const priceInput = document.getElementById("item-price");
  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value;

    const addTaxDom = document.getElementById("add-tax-price");
    addTaxDom.innerHTML = (Math.floor(inputValue * 0.1));

    const profitNumber = document.getElementById("profit");
    const valueResult = inputValue * 0.1;
    profitNumber.innerHTML = (Math.floor(inputValue - valueResult));
  });
};

window.addEventListener('load', post);