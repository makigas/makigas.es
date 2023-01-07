/**
 * @param {HTMLElement} node the node where the class should be located.
 * @param {string} className the class name that we want to find.
 */
function locateParentByClass(node, className) {
  do {
    if (node.classList.contains(className)) {
      return node;
    }
    node = node.parentElement;
  } while (node);
  return null;
}

/**
 * Set up an event listener for clicking in the navbar.
 * @param {HTMLElement} node the node to attach the click listener.
 * @param {function} callback a callback to be called when clicking.
 */
function configureClickListener(node, callback) {
  if (node) {
    node.addEventListener("click", () => {
      const navbar = locateParentByClass(node, "navbar");
      if (navbar) {
        callback({ navbar, node });
      }
    });
  }
}

configureClickListener(document.getElementById("sToggleMenu"), ({ navbar }) => {
  navbar.classList.toggle("navbar--menu");
});
configureClickListener(document.getElementById("sExploreMenu"), ({ navbar }) => {
  navbar.classList.toggle("navbar--menu");
});

configureClickListener(document.getElementById("sToggleSearch"), ({ navbar }) => {
  navbar.classList.toggle("navbar--searching");
  navbar.classList.remove("navbar--menu");
  navbar.querySelector("#q").focus();
});

configureClickListener(document.getElementById("sCurtain"), ({ navbar }) => {
  navbar.classList.remove("navbar--menu");
});

configureClickListener(document.getElementById("sHideSearch"), ({ navbar }) => {
  navbar.classList.remove("navbar--searching");
});

const search = document.querySelector(".navbar .searchbar__search");
if (search) {
  search.addEventListener("keyup", (e) => {
    // If you press ESC, you stop searching automatically.
    if (e.keyCode === 27) {
      document.querySelector(".navbar").classList.remove("navbar--searching");
    }
  });
}
