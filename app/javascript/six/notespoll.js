const buttons = document.querySelectorAll(".videoinfo__nonotes__btn");
[...buttons].forEach((button) => {
  button.addEventListener("click", () => {
    const cast = button.innerText;
    if (window.plausible) {
      window.plausible("Shownotes", { props: { cast } });
    } else {
      console.log("Casted", cast);
    }

    document.querySelector(".article__survey").innerText = "Gracias por ayudar a mejorar esta página.";
  });
});
