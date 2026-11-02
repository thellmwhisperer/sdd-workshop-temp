// The shops, the catalogue and saving in the browser. Plain functions, no screen.

var SHOPS = ["Old town", "Graslin", "Île de Nantes", "Chantenay"];

var CATALOGUE = [
  { product: "jacket", sizes: ["M", "L"], colours: ["black", "navy"] },
  { product: "sandal", sizes: ["38", "39"], colours: ["tan", "black"] }
];

var STORAGE_KEY = "sabot-state";

// optionsFor(product): { sizes, colours } the product comes in; empty lists for an unknown product.
function optionsFor(product) {
  var found = CATALOGUE.filter(function (p) {
    return p.product === product;
  })[0];
  return found
    ? { sizes: found.sizes.slice(), colours: found.colours.slice() }
    : { sizes: [], colours: [] };
}

// loadState(storage): { stock, reservations } as saved, or nothing counted and no reservations.
function loadState(storage) {
  var text = storage.getItem(STORAGE_KEY);
  if (text) {
    try {
      var saved = JSON.parse(text);
      if (saved && saved.stock && Array.isArray(saved.reservations)) {
        return { stock: saved.stock, reservations: saved.reservations };
      }
    } catch (e) {
      // unreadable data counts as nothing saved
    }
  }
  return { stock: emptyStock(), reservations: [] };
}

// saveState(storage, state): keeps { stock, reservations } under one key.
function saveState(storage, state) {
  storage.setItem(STORAGE_KEY, JSON.stringify({
    stock: state.stock,
    reservations: state.reservations
  }));
}
