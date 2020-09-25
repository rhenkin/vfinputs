function getContinuousColorScaleByScheme(scheme, domain) {
  var interpolate_string = "interpolate" + scheme.charAt(0).toUpperCase() + scheme.slice(1);
  if (domain.length == 2){
    
    return d3.scaleSequential()
              .domain(domain) 
              .interpolator(d3[interpolate_string]);
  }
  else {
    
    return d3.scaleDiverging()
            .domain(domain) 
            .interpolator(d3[interpolate_string]); 
  }
}

function getContinuousColorScaleByInterpolation(colorlist, domain) {
  return d3.scaleSequential()
            .domain(domain)
            .interpolator(d3.interpolateRgbBasis(colorlist));
}

function getDiscreteColorScaleByScheme(scheme, domain, numcolors) {
  var scheme_string = "scheme" + scheme.charAt(0).toUpperCase() + scheme.slice(1);
  if (domain.length == 2){
    
    /** let step = (domain[1] - domain[0])/numcolors;
    let range = [];
    for (let i = domain[0]; i < domain[1]; i += step)
        range.push(i); **/
    //console.log(d3[scheme_string][numcolors]);
    
    return d3.scaleQuantize()
              .domain(domain) 
              .range(d3[scheme_string][numcolors]);
  }
  else {
    
    return d3.scaleDiverging()
            .domain(domain) 
            .interpolator(d3[interpolate_string]); 
  }
}

function getCategoricalColorScaleByScheme(scheme, domain) {
  
  var scheme_string = "scheme" + scheme.charAt(0).toUpperCase() + scheme.slice(1);
  return d3.scaleOrdinal()
          .domain(domain)
          .range(d3[scheme_string]);
}          

function getCategoricalColorScaleByColors(colorlist, domain) {
  
  return d3.scaleOrdinal()
          .domain(domain)
          .range(colorlist);
}

function createColorScale(type,colorconfig, domain) {
    
    if (type == "continuous") {
      if (colorconfig.type == "scheme") {
        
        return getContinuousColorScaleByScheme(colorconfig.scheme, domain);
        
      }
      else if (colorconfig.type == "colors") {
        
        return getContinuousColorScaleByInterpolation(colorconfig.colorlist, domain);
      }
    }
    else if (type == "discrete") {
      if (colorconfig.type == "scheme") {
        
        return getDiscreteColorScaleByScheme(colorconfig.scheme, domain, colorconfig.numcolors);
        
      }
      else if (colorconfig.type == "colors") {
        
        return getDiscreteColorScaleByInterpolation(colorconfig.colorlist, domain, colorconfig.numcolors);
      }
    }
    else if (type == "categorical") {
      if (colorconfig.type == "scheme") {
        return getCategoricalColorScaleByScheme(colorconfig.scheme, domain);
      }
      if (colorconfig.type == "colors") {
        return getCategoricalColorScaleByColors(colorconfig.colorlist, domain);
      } 
    }
}