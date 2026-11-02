// Reservations: hold units of a variant for a named customer. Plain functions, no screen.
// A reservation is { id, shop, product, size, colour, units, customer, madeAt, status }.

// nextId(reservations): an id no reservation of the list has.
function nextId(reservations) {
  var n = reservations.length + 1;
  var taken = reservations.map(function (r) {
    return r.id;
  });
  while (taken.indexOf("r" + n) >= 0) {
    n += 1;
  }
  return "r" + n;
}

// reserve(stock, reservations, request, now): a new list with the reservation added;
// throws when the customer is missing, the units are not a whole number above zero,
// or more than are free. The list given is left as it was.
function reserve(stock, reservations, request, now) {
  if (typeof request.customer !== "string" || request.customer.trim() === "") {
    throw new Error("the customer name is missing");
  }
  var units = request.units;
  if (typeof units !== "number" || isNaN(units) || units % 1 !== 0 || units < 1) {
    throw new Error("units must be a whole number of at least 1");
  }
  var variant = { product: request.product, size: request.size, colour: request.colour };
  var free = freeUnits(stock, reservations, request.shop, variant, now);
  if (units > free) {
    throw new Error("only " + free + " are free in " + request.shop);
  }
  return reservations.concat([{
    id: nextId(reservations),
    shop: request.shop,
    product: request.product,
    size: request.size,
    colour: request.colour,
    units: units,
    customer: request.customer.trim(),
    madeAt: now,
    status: "active"
  }]);
}

// findActive(reservations, id, now): the reservation with that id; throws when it is missing or not active.
function findActive(reservations, id, now) {
  var found = reservations.filter(function (r) {
    return r.id === id;
  })[0];
  if (!found) {
    throw new Error("no reservation " + id);
  }
  if (!isActive(found, now)) {
    throw new Error("reservation " + id + " is not active");
  }
  return found;
}

// withStatus(reservations, id, status): a new list where that reservation has the status.
function withStatus(reservations, id, status) {
  return reservations.map(function (r) {
    return r.id === id ? Object.assign({}, r, { status: status }) : r;
  });
}

// collect(stock, reservations, id, now): { stock, reservations } with the units out of the
// shop's stock and the reservation "collected"; throws when it is not active.
function collect(stock, reservations, id, now) {
  var r = findActive(reservations, id, now);
  var variant = { product: r.product, size: r.size, colour: r.colour };
  return {
    stock: setCount(stock, r.shop, variant, countOf(stock, r.shop, variant) - r.units),
    reservations: withStatus(reservations, id, "collected")
  };
}

// cancel(reservations, id, now): a new list where the reservation is "cancelled"; throws when it is not active.
function cancel(reservations, id, now) {
  findActive(reservations, id, now);
  return withStatus(reservations, id, "cancelled");
}
