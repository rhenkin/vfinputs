var continuousLegendFilterBinding = new Shiny.InputBinding();

$.extend(continuousLegendFilterBinding, {

  find: function(scope) {

    return $(scope).find(".continuous-color-filter");

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
      $(el).on("end.continuousLegendFilterBinding", function(event,args) {
          callback();
      });

  },

  // Unbind
  unsubscribe: function(el) {

    $(el).off(".continuousLegendFilterBinding");
  },

  // Receive messages from the server.
  // Messages sent by update...() are received by this function.
  receiveMessage: function(el, data) {

    let $el = $(el);

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
      let start = data.hasOwnProperty("start") ? data.selection : brush.extent[0];
      let end = data.hasOwnProperty("end") ? data.selection : brush.extent[1];
      let new_selection = [legend_scale(start), legend_scale(end)];
      brush.move($el.find("#g-filter-"+$el.attr("id")), new_selection);
    }

    updateLabel(data.label, this._getLabelNode(el));
    $el.trigger("end");

  },
  getType: function(el) {
    return "vfinputs.continuousLegendFilter";
  },
  _getLabelNode: function _getLabelNode(el) {
      return $(el).find('label[for="' + Shiny.$escape(el.id) + '"]');
    },
  _createLegend: function(el) {

    //console.log("_attachSvg");
    let $el = $(el);
    let size = $el.data("size");
    let orient = $el.data("orient");
    let min = $el.data("min");
    let max = $el.data("max");
    let thickness = $el.data("thickness");

    let options = $el.data("options");

    let inner_width =  size.width;
    let inner_height = size.height;
    let domain = [min, max];

    /** We set the inverted_domain_scale with 0-100 to create ticks **/
    let inverted_domain_scale = d3.scaleLinear()
          .domain([0,100])
          .range([min, max]);
    $el.data("inverted_domain_scale", inverted_domain_scale);

    var legend_scale = d3.scaleLinear()
          .domain([min,max])
          .range([0, (orient == "bottom" || orient == "top")? inner_width : inner_height] );
    $el.data("legend_scale", legend_scale);

    let g = d3.select($el[0]).select("g");

    let tick_values = [];
    let argformat;
    //If user has provided custom ticks or number of ticks
    if (options.hasOwnProperty("ticks")) {

      if (typeof(options.ticks) == "object") {

        tick_values = options.ticks.map(function(d) { return d; });
        argformat = function(d) { return d };

      }
      else {
        if (parseInt(options.ticks) > 0) {
        //If ticks is numeric we divide the domain of the scale evenly by the number of ticks provided
        //We always include min and max, so 3 ticks mean min, max and a tick right in the middle
        let step = 100/(options.ticks-1);
        tick_values = [];
        for (let i =0; i <= 100; i += step)
            tick_values.push(inverted_domain_scale(i));
        }
      }

    } //By default we set 5 ticks.
      else {
      tick_values = d3.range(0,5)
      .map(function(d) { return inverted_domain_scale(d*25); });
    }

    //TODO: validate format
    if (options.hasOwnProperty("format")) {
      argformat = d3.format(options.format);
    }
    else if (typeof(argformat) === undefined) argformat = null;

    addAxis(g, orient, legend_scale, thickness, tick_values, argformat);

    let hide_brush_labels = options.hasOwnProperty("hide_brush_labels") ? options.hide_brush_labels : false;
    let _brush = getBrush(g, "continuousLegendFilterBinding", orient, inner_width, inner_height,
                      legend_scale, thickness, hide_brush_labels);

    //attach brush because we reuse it when receiving message from the server
    // BUT not sure if this is needed because all of this is client side
    $el.data("brush", _brush);
    g.call(_brush);

    }
});

Shiny.inputBindings.register(continuousLegendFilterBinding, 'vfinputs.continuousLegendFilter');
