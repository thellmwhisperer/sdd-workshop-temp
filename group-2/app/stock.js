// Stock per shop and per variant (product, size, colour). Plain functions, no screen.
// A stock is { "<shop>": { "<variant key>": count } }; functions return a new stock.

// keyOf(variant): the text that names one variant.
function keyOf(variant) {
  return JSON.stringify([variant.product, variant.size, variant.colour]);
}

// emptyStock(): a stock with nothing set.
function emptyStock() {
  return {};
}

// setCount(stock, shop, variant, n): a new stock with that count; throws when n is below zero.
function setCount(stock, shop, variant, n) {
  if (typeof n !== "number" || isNaN(n) || n < 0) {
    throw new Error("stock cannot be set below zero");
  }
  var next = {};
  Object.keys(stock).forEach(function (name) {
    next[name] = Object.assign({}, stock[name]);
  });
  next[shop] = Object.assign({}, next[shop]);
  next[shop][keyOf(variant)] = n;
  return next;
}

// countOf(stock, shop, variant): the count, 0 when never set.
function countOf(stock, shop, variant) {
  var counts = stock[shop];
  if (!counts || !Object.prototype.hasOwnProperty.call(counts, keyOf(variant))) {
    return 0;
  }
  return counts[keyOf(variant)];
}

// A reservation holds its units for 48 hours.
var RESERVATION_MS = 48 * 60 * 60 * 1000;

// isActive(reservation, now): status is "active" and less than 48 hours have passed since madeAt.
function isActive(reservation, now) {
  return reservation.status === "active" && now - reservation.madeAt < RESERVATION_MS;
}

// freeUnits(stock, reservations, shop, variant, now): the count minus the units held by active reservations.
function freeUnits(stock, reservations, shop, variant, now) {
  var held = 0;
  reservations.forEach(function (r) {
    if (r.shop === shop && keyOf(r) === keyOf(variant) && isActive(r, now)) {
      held += r.units;
    }
  });
  return countOf(stock, shop, variant) - held;
}
