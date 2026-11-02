// The page: pick a variant and see every shop with its free units. It only shows what the
// rules return; the rules live in stock.js, reservations.js and data.js.

// startPage(root, storage, now): builds the page inside root; now() gives the time.
function startPage(root, storage, now) {
  var state = loadState(storage);
  var message = "";

  function make(tag, className, text) {
    var el = document.createElement(tag);
    if (className) {
      el.className = className;
    }
    if (text !== undefined) {
      el.textContent = text;
    }
    return el;
  }

  // choice(name, label, values, selected): a labelled drop-down.
  function choice(name, label, values, selected) {
    var wrap = make("label", "", label + " ");
    var select = make("select");
    select.name = name;
    values.forEach(function (v) {
      var option = make("option", "", v);
      option.value = v;
      select.appendChild(option);
    });
    select.value = selected;
    wrap.appendChild(select);
    root.appendChild(wrap);
    return select;
  }

  var picked = { product: CATALOGUE[0].product, size: "", colour: "" };

  // keep: the size and colour stay when the product offers them, else the first one.
  function keep(options) {
    if (options.sizes.indexOf(picked.size) < 0) {
      picked.size = options.sizes[0];
    }
    if (options.colours.indexOf(picked.colour) < 0) {
      picked.colour = options.colours[0];
    }
  }

  function draw() {
    var options = optionsFor(picked.product);
    keep(options);
    root.textContent = "";
    var products = CATALOGUE.map(function (p) {
      return p.product;
    });
    choice("product", "Product", products, picked.product).addEventListener("change", function (e) {
      picked.product = e.target.value;
      message = "";
      draw();
    });
    choice("size", "Size", options.sizes, picked.size).addEventListener("change", function (e) {
      picked.size = e.target.value;
      message = "";
      draw();
    });
    choice("colour", "Colour", options.colours, picked.colour).addEventListener("change", function (e) {
      picked.colour = e.target.value;
      message = "";
      draw();
    });
    root.appendChild(make("p", "message", message));

    var variant = { product: picked.product, size: picked.size, colour: picked.colour };
    var list = make("ul", "shops");
    SHOPS.forEach(function (shop) {
      var free = freeUnits(state.stock, state.reservations, shop, variant, now());
      var li = make("li");
      li.setAttribute("data-shop", shop);
      li.appendChild(make("span", "name", shop + ": "));
      li.appendChild(make("span", "free", String(free)));
      li.appendChild(make("span", "", " free "));
      var input = make("input");
      input.type = "number";
      input.value = String(countOf(state.stock, shop, variant));
      li.appendChild(input);
      var set = make("button", "set", "Set count");
      set.type = "button";
      set.addEventListener("click", function () {
        try {
          state = { stock: setCount(state.stock, shop, variant, Number(input.value)),
            reservations: state.reservations };
          saveState(storage, state);
          message = "";
        } catch (e) {
          message = e.message;
        }
        draw();
      });
      li.appendChild(set);
      if (free > 0) {
        var customer = make("input");
        customer.name = "customer";
        customer.placeholder = "Customer name";
        var units = make("input");
        units.name = "units";
        units.type = "number";
        units.value = "1";
        var reserveButton = make("button", "reserve", "Reserve");
        reserveButton.type = "button";
        reserveButton.addEventListener("click", function () {
          try {
            var request = { shop: shop, product: variant.product, size: variant.size,
              colour: variant.colour, units: Number(units.value), customer: customer.value };
            state = { stock: state.stock,
              reservations: reserve(state.stock, state.reservations, request, now()) };
            saveState(storage, state);
            message = "";
          } catch (e) {
            message = e.message;
          }
          draw();
        });
        li.appendChild(customer);
        li.appendChild(units);
        li.appendChild(reserveButton);
      }
      list.appendChild(li);
    });
    root.appendChild(list);
    root.appendChild(reservationList());
  }

  // reservationList(): every active reservation with its end, a collect and a cancel button.
  function reservationList() {
    var list = make("ul", "reservations");
    state.reservations.filter(function (r) {
      return isActive(r, now());
    }).forEach(function (r) {
      var li = make("li");
      li.setAttribute("data-id", r.id);
      li.appendChild(make("span", "customer", r.customer));
      li.appendChild(make("span", "", " · " + r.product + " " + r.size + " " + r.colour + " · "));
      li.appendChild(make("span", "shop", r.shop));
      li.appendChild(make("span", "", " · "));
      li.appendChild(make("span", "units", String(r.units)));
      li.appendChild(make("span", "", " units · ends "));
      li.appendChild(make("span", "ends", new Date(r.madeAt + RESERVATION_MS).toLocaleString()));
      li.appendChild(make("span", "", " "));
      li.appendChild(actionButton("collect", "Collected", function () {
        var done = collect(state.stock, state.reservations, r.id, now());
        state = { stock: done.stock, reservations: done.reservations };
      }));
      li.appendChild(actionButton("cancel", "Cancel", function () {
        state = { stock: state.stock, reservations: cancel(state.reservations, r.id, now()) };
      }));
      list.appendChild(li);
    });
    return list;
  }

  // actionButton(className, label, change): a button that runs change, saves, and draws again.
  function actionButton(className, label, change) {
    var button = make("button", className, label);
    button.type = "button";
    button.addEventListener("click", function () {
      try {
        change();
        saveState(storage, state);
        message = "";
      } catch (e) {
        message = e.message;
      }
      draw();
    });
    return button;
  }

  draw();
}
