function addAxis(parent, orient, legend_scale, thickness, argtickvalues, argformat = null) {

  let axisLeg;
  let tx = 0;
  let ty = 0;
  let format;

  if (orient == "right") {
    axisLeg = d3.axisRight(legend_scale);
    format = d3.format("4");

    tx = 30+thickness;
    ty = 0;
  } else if (orient == "left") {
    axisLeg = d3.axisLeft(legend_scale);
    format = d3.format("4");

    tx = 15;
    ty = 0;
  } else if (orient == "bottom") {
    axisLeg = d3.axisBottom(legend_scale);
    format = d3.format("2");
    ty = 20+thickness;
  } else {
    axisLeg = d3.axisTop(legend_scale);
    format = d3.format("2");
    ty = 25;
  }

  if (argformat) {
    format = argformat;
  }

  if (argtickvalues.length === 0) {
     axisLeg
     .tickValues([])
     .tickSizeOuter(0);
  }
  else {
    axisLeg
      .tickFormat(format)
      .tickValues(argtickvalues)
      .ticks(argtickvalues.length);
  }

  let axis_g = parent
    .append("g")
    .attr("class", "axis")
    .attr("transform", "translate(" + tx + "," + ty + ")")
    .call(axisLeg);

}

function getBrush( parent, type, orient, width, height, legend_scale, thickness, hide_brush_labels, aux_scale = null) {

  // Update labels after moving filter
  function move_labels(extent, pos) {
    let invert_s = legend_scale.invert(extent[0]);
    let invert_e = legend_scale.invert(extent[1]);

    // If discrete, snap the labels
    if (type == "discreteLegendFilterBinding") {
      invert_s = parseFloat(aux_scale[Math.round(invert_s)]);
      invert_e = parseFloat(aux_scale[Math.round(invert_e)]);
    }

    parent
      .select("#label_start")
      .attr(pos, extent[0])
      .text(invert_s.toFixed(2))
      .style("display", "inherit");

    parent
      .select("#label_end")
      .attr(pos, extent[1])
      .text(invert_e.toFixed(2))
      .style("display", "inherit");
  }

  let label_start = parent
    .append("text")
    .attr("class", "brushLabel")
    .attr("id", "label_start")
    .style("fill", "black")
    .style("visibility", (hide_brush_labels) ? "hidden" : "inherit");

  let label_end = parent
    .append("text")
    .attr("class", "brushLabel")
    .attr("id", "label_end")
    .style("fill", "black")
    .style("visibility", (hide_brush_labels) ? "hidden" : "inherit");

  let x1, x2, y1, y2;
  let brushType;
  if (orient == "right") {
    brushType = "y";

    label_start
      .attr("text-anchor", "end")
      .attr("dy", ".3em")
      .attr("x", 25)
      .attr("y", 0);

    label_end
      .attr("text-anchor", "end")
      .attr("dy", ".3em")
      .attr("x", 25)
      .attr("y", 0);

    x1 = 30;
    y1 = 0;
    x2 = 70+thickness;
    y2 = height;
  } else if (orient == "left") {
    brushType = "y";

    label_start
      .attr("text-anchor", "start")
      .attr("dy", ".3em")
      .attr("x", 20+thickness)
      .attr("y", 0);

    label_end
      .attr("text-anchor", "start")
      .attr("dy", ".3em")
      .attr("x", 20+thickness)
      .attr("y", 0);

    x1 = -25;
    y1 = 0;
    x2 = 15+thickness;
    y2 = height;
  } else if (orient == "bottom") {
    brushType = "x";

    label_start
      .attr("text-anchor", "middle")
      .attr("dy", "-.25em")
      .attr("x", 50)
      .attr("y", 20);

    label_end
      .attr("text-anchor", "middle")
      .attr("dy", "-.25em")
      .attr("x", 50)
      .attr("y", 20);

    x1 = 0;
    y1 = 20;
    x2 = width;
    y2 = 40+thickness;
  } else if (orient == "top") {
    brushType = "x";

    label_start
      .attr("text-anchor", "middle")
      .attr("dy", ".5em")
      .style("fill", "black")
      .attr("x", 50)
      .attr("y", 30+thickness);

    label_end
      .attr("text-anchor", "middle")
      .attr("dy", ".5em")
      .attr("x", 50)
      .attr("y", 30+thickness);

    x1 = 0;
    y1 = 5;
    x2 = width;
    y2 = 25+thickness;
  }

  return d3["brush" + brushType.toUpperCase()]()
    .extent([
      [x1, y1],
      [x2, y2],
    ])
    .on("end", function (e) {
      let extent = d3.event.selection;
      if (type == "discreteLegendFilterBinding") {
        if (!d3.event.sourceEvent) return;
        if (d3.event.sourceEvent) { if (d3.event.sourceEvent.type === "brush") return; }

        if (extent) {
          let d0 = extent.map(legend_scale.invert); //.map(Math.round);
          let d1 = d0.map(Math.round);

          // If empty when rounded, use floor instead.
          if (d1[0] >= d1[1]) {
            d1[0] = Math.floor(d0[0]);
            d1[1] = d1[0] + 1;
          }

          move_labels(d1.map(legend_scale), brushType);

          d3.select(this)
            .transition()
            .call(d3.event.target.move, d1.map(legend_scale));
        }

      }

      if (!extent) {
        parent.select("#label_start").style("display", "none");
        parent.select("#label_end").style("display", "none");
        $(this).data("extent", null); //this = g
        $(this).trigger("end." + type);
        return;
      }
      else {

        let invert_s, invert_e;
        if (aux_scale) {
          invert_s = aux_scale[Math.round(legend_scale.invert(extent[0]))];
          invert_e = aux_scale[Math.round(legend_scale.invert(extent[1]))];
          $(this).data("extent", [invert_s, invert_e]);
        } else {
          invert_s = legend_scale.invert(extent[0]);
          invert_e = legend_scale.invert(extent[1]);
          $(this).data("extent", [invert_s, invert_e]); //this = g
        }

        if (type == "continuousLegendFilterBinding")
          move_labels(extent, brushType);

        $(this).trigger("end." + type);
      }
    });
}

function updateLabel(labelTxt, labelNode) {
  // Only update if label was specified in the update method
  if (typeof labelTxt === "undefined") return;

  if (labelNode.length !== 1) {
    throw new Error("labelNode must be of length 1");
  } // Should the label be empty?


  var emptyLabel = $.isArray(labelTxt) && labelTxt.length === 0;

  if (emptyLabel) {
    labelNode.addClass("shiny-label-null");
  } else {
    labelNode.text(labelTxt);
    labelNode.removeClass("shiny-label-null");
  }
}
