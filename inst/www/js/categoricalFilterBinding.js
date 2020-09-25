var categoricalColorFilterBinding = new Shiny.InputBinding();

$.extend(categoricalColorFilterBinding, {

  find: function(scope) {

    return $(scope).find(".categorical-color-filter");

  },
   getId: function(el) {
    return $(el).attr("id");
  },
  // this method will be called on initialisation
  initialize: function(el) {

    //console.log("initialize");
    this._createLegend(el);

  },

  // this method will also be called on initialisation
  // and each time when the callback is triggered via the event bound in subscribe
  getValue: function(el) {

    //console.log("getValue");
    let values = $(el).find(".selected").map(function() { return $(this).data("value"); }).toArray();
    //console.log(values);
    if (values.length === 0) return null;
    else
    return values;
  },

  // we want to subscribe to changes in our component
  subscribe: function(el, callback) {

      //console.log("subscribe");
      $(el).on("toggled.categoricalColorFilterBinding", function(event,args) {
          callback();
      });
  },

  // Unbind
  unsubscribe: function(el) {

    $(el).off(".categoricalColorFilterBinding");
  },

  // Receive messages from the server.
  // Messages sent by update...() are received by this function.
  receiveMessage: function(el, data) {

    let $el = $(el);

    if (data.hasOwnProperty("select")) {
      let selected = data.select;
      for (let i = 0; i < selected.length; i++)
        $el.find("*[data-value='"+selected[i]+"']").addClass("selected");
      }

    if (data.hasOwnProperty("deselect")) {
      let deselect = data.deselect;
      for (let i = 0; i < deselect.length; i++)
        $el.find("*[data-value='"+deselect[i]+"']").removeClass("selected");
      }

    updateLabel(data.label, this._getLabelNode(el));
    $el.trigger("toggled");

  },
  getType: function(el) {
    return "vfinputs.categoricalColorFilter";
  },
  _getLabelNode: function _getLabelNode(el) {
      return $(el).find('label[for="' + Shiny.$escape(el.id) + '"]');
    },
  _createLegend: function(el) {

    //console.log("_attachSvg");
    let $el = $(el);

    let multiple = $el.data("multiple");

    $("."+el.id).on("click", function(clicked) {
      if (multiple == "FALSE") {
        $("."+el.id+".selected").not($(this)).toggleClass("selected");
      }
      $(this).toggleClass("selected");

      $el.trigger("toggled.categoricalColorFilterBinding");
    });

  }
});

Shiny.inputBindings.register(categoricalColorFilterBinding, 'vfinputs.categoricalColorFilter');
