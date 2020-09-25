function createGradient(parent, id, orient, inverted_colour_scale, colour_scale) {
  
  var colourGradient = parent
      .select("defs")
      .append("linearGradient")
      .attr("id","color-grad-"+id);
  
  if ((orient == "right") || (orient == "left")) {
    colourGradient
        .attr("x1", "0")
        .attr("y1", "0")
        .attr("y2", "1")
        .attr("x2", "0");
  }
  else {
    colourGradient
        .attr("x1", "0")
        .attr("y1", "0")
        .attr("y2", "0")
        .attr("x2", "1");
  }
  
   var stops = [];
  
    for(var i=0; i<=100;i++) {
      
      stops[i] = {offset: i + '%', colour: colour_scale(inverted_colour_scale(i)) };
  }
  
  colourGradient.selectAll("stop")
    .data(stops)
    .enter().append("stop")
    .attr("offset", function(d) { 
      return d.offset; 
    })
    .attr("stop-color", function(d) { 
      return d.colour; 
    });
      
}

function addGradientRect(parent, id, orient, width, height) {
  
  let gradrect = parent
                .append("rect")
                 .style("fill", "url(#color-grad-"+id+")");
                 
  if (orient == 'right') {
    gradrect
    .attr("x", 30)
    .attr("y", 0)
    .attr("width", 20)
    .attr("height", height);
    
  } else if (orient == 'left') {
    gradrect
    .attr("x", 30)
    .attr("y", 0)
    .attr("width", 20)
    .attr("height", height);
    
  } else if (orient == 'top') {
    gradrect
    .attr("x", 0)
    .attr("y", 25)
    .attr("width", width)
    .attr("height", 20);
  } else {
    gradrect
    .attr("x", 0)
    .attr("y", 20)
    .attr("width", width)
    .attr("height", 20);
  }
  
}
//Credits: Mike Bostock
//Source: https://observablehq.com/@mbostock/color-ramp
function ramp(parent, color, n) {
  //const canvas = DOM.canvas(n, 1);
  //let canvas = parent.append("canvas").attr("width",n).attr("height",1);
   let canvas = document.createElement("canvas");
   canvas.width = n;
   canvas.height = 1;
  let context = canvas.getContext("2d");
  for (let i = 0; i < n; ++i) {
    context.fillStyle = color(i / (n - 1));
    context.fillRect(i, 0, 1, 1);
  }
  return canvas;
}

function addRamp(parent, color, width, height, n = 256) {
   parent.append("image")
        .attr("x", 0)
        .attr("y", 25)
        .attr("width", width+1)
        .attr("height", 20)
        .attr("preserveAspectRatio", "none")
        .attr("xlink:href",
              ramp(parent, color.copy().domain(d3.quantize(d3.interpolate(0, 1), n)),n).toDataURL());
}

function addRects(parent, id, colour_scale, inverted_domain_scale, orient, width, height, n = 512) {
    if ((orient == "bottom") || (orient == "top")) {
        
        let convert_to_domain = d3.scaleLinear()
                                .domain([-1,n-1])
                                .range(colour_scale.domain());
        let color_lines = [];
        for (let i =0; i < n; i++)
            color_lines.push(convert_to_domain(i-1));
        
        var x = d3.scaleLinear()
                //.domain([-1, n - 1])
                .domain([-1, n-1])
                .range([0, width]);
        
        parent.append("g")
          .selectAll("rect")
          .data(color_lines)
          .join("rect")
          .attr("x", function(d,i) { return x(i - 1) })
          .attr("y", (orient == "bottom") ? 20 : 25)
          .attr("width", function(d,i) { return x(i) - x(i - 1); })
          .attr("height", 20)
          .attr("fill", function(d,i) { return colour_scale(d); } );

    }
    else {
      
       var y = d3.scaleLinear()
                .domain([-1, colour_scale.range().length - 1])
                .range([0, height]);
      
       parent.append("g")
          .selectAll("rect")
          .data(colour_scale.range())
          .join("rect")
          .attr("y", function(d,i) { return y(i - 1) })
          .attr("x", 30)
          .attr("height", function(d,i) { return y(i) - y(i - 1); })
          .attr("width", 20)
          .attr("fill", function(d) { return d; } );
    }
}

function addDiscreteRect(parent, id, orient, colour_scale, width, height) {
  
    if ((orient == "bottom") || (orient == "top")) {
      
        var x = d3.scaleLinear()
                .domain([-1, colour_scale.range().length - 1])
                .range([0, width]);
        
        parent.append("g")
          .selectAll("rect")
          .data(colour_scale.range())
          .join("rect")
          .attr("x", function(d,i) { return x(i - 1) })
          .attr("y", (orient == "bottom") ? 20 : 25)
          .attr("width", function(d,i) { return x(i) - x(i - 1); })
          .attr("height", 20)
          .attr("fill", function(d) { return d; } );

    }
    else {
      
       var y = d3.scaleLinear()
                .domain([-1, colour_scale.range().length - 1])
                .range([0, height]);
      
       parent.append("g")
          .selectAll("rect")
          .data(colour_scale.range())
          .join("rect")
          .attr("y", function(d,i) { return y(i - 1) })
          .attr("x", 30)
          .attr("height", function(d,i) { return y(i) - y(i - 1); })
          .attr("width", 20)
          .attr("fill", function(d) { return d; } );
    }
    
}