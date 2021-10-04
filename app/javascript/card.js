const pay = () => {
  Payjp.setPublickKey(pk_test_47eb80206bf31bebd11a505a);
  const submit = document.getElementById("button");
  submit.addEventListener("click", (e) => {
    e.preventDefault();

    const formResult = document.getElementById("charge-form");
    const formDate = new FormData(formResult)

    const card = {
      number: formDate.get(""),
      exp_month: formDate.get(""),
      exp_year: `20${formDate.get("")}`,
      cvc: formDate.get("")

    }

    console.log("フォーム送信時にイベント発火");
  });
};

window.addEventListener("load", pay);