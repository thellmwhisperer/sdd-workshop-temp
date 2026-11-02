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
