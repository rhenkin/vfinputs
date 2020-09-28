var discreteLegendFilterBinding = new Shiny.InputBinding();

$.extend(discreteLegendFilterBinding, {

  find: function(scope) {

    return $(scope).find(".discrete-color-filter");

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
    //console.log($(el).find('g').data('extent'));
    let value = $(el).find('g').data('extent');
    if (!value) return null;
    else
    return value;
  },

  // we want to subscribe to changes in our component
  subscribe: function(el, callback) {

      //console.log("subscribe");
      $(el).on("end.discreteLegendFilterBinding", function(event,args) {
          callback();
      });
  },

  // Unbind
  unsubscribe: function(el) {

    $(el).off(".discreteLegendFilterBinding");
  },

  // Receive messages from the server.
  // Messages sent by update...() are received by this function.
  receiveMessage: function(el, data) {

    var $el = $(el);
    if (data.hasOwnProperty("min") || data.hasOwnProperty("max")) {
        if (data.hasOwnProperty("min")) $el.data("min", data.min);
        if (data.hasOwnProperty("max")) $el.data("max", data.max);
        $el.empty();
        this._createLegend(el);
    }

    if (data.hasOwnProperty("start") || data.hasOwnProperty("end") ) {
      //let orient = $el.data("orient");
      let legend_scale = $el.data("legend_scale");
      let brush = $el.data("brush");
      let start = data.hasOwnProperty("start") ? data.start : brush.extent[0];
      let end = data.hasOwnProperty("end") ? data.end : brush.extent[1];
      let new_selection = [legend_scale(start), legend_scale(end)];
      brush.move($el.find("#g-filter-"+$el.attr("id")), new_selection);
    }

    updateLabel(data.label, this._getLabelNode(el));
    $el.trigger("end");

  },
  getType: function(el) {
    return "vfinputs.discreteLegendFilter";
  },
  _getLabelNode: function _getLabelNode(el) {
      return $(el).find('label[for="' + Shiny.$escape(el.id) + '"]');
    },
  _createLegend: function(el) {

      var $el = $(el);
      let size = $el.data("size");
      let orient = $el.data("orient");
      let min = $el.data("min");
      let max = $el.data("max");
      let thickness = $el.data("thickness");

      let options = $el.data("options");

      let inner_width =  size.width;
      let inner_height = size.height;
      let domain = [min, max];

      let g = d3.select($el[0]).select("g");

      var inverted_domain_scale = d3.scaleLinear()
            .domain([0,100])
            .range([min, max]);
      $el.data("inverted_domain_scale", inverted_domain_scale);

      var legend_scale = d3.scaleLinear()
            .domain([0, options.numcolors])
            .range([0, inner_width > inner_height? inner_width : inner_height] );
      $el.data("legend_scale", legend_scale);

      let tick_scale = d3.scaleQuantize()
                .domain(domain)
                .range(d3.range(options.numcolors));

      let base_ticks = Array.prototype.concat(min,tick_scale.thresholds(),max);

      let tick_values;
      let argformat;

      if (options.hasOwnProperty("format")) {
        base_ticks = base_ticks.map(d3.format(options.format));
        tick_values = d3.range(base_ticks.length);
        argformat = function(i) { return base_ticks[i]; };
      }
      else {
        tick_values = d3.range(base_ticks.length);
        argformat = function(i) { return Math.trunc(base_ticks[i]); };
      }

      addAxis(g, orient, legend_scale, thickness, tick_values, argformat);

      let hide_brush_labels = options.hasOwnProperty("hide_brush_labels");

      var _brush = getBrush(g, "discreteLegendFilterBinding", orient,
                              inner_width, inner_height, legend_scale, thickness, hide_brush_labels, base_ticks);
      //attach brush because we reuse it when receiving message from the server
      // BUT not sure if this is needed because all of this is client side
      $el.data("brush", _brush);
      g.call(_brush);

    }
});

Shiny.inputBindings.register(discreteLegendFilterBinding, 'vfinputs.discreteLegendFilter');
