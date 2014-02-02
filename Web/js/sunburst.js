//specify sunburst size
var width = 300, //420
    height = 300,//350
    radius = Math.min(width, height) / 2;

//add element to document body
var svg = d3.select("#sunburst").append("svg")
    .attr("width", width)
    .attr("height", height+10)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height * .52 + ")");

//d3 layout magic
var partition = d3.layout.partition()
    .sort(null)
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return 1; });

var arc = d3.svg.arc()
    .startAngle(function(d) { return d.x; })
    .endAngle(function(d) { return d.x + d.dx; })
    .innerRadius(function(d) { return Math.sqrt(d.y); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

var path; //for visibility. Might not be necessary

//load animation
window.onload = function(){
  var value = function(d) { return d.size; };

    path
        .data(partition.value(value).nodes)
      .transition()
        .duration(5000)
        .attrTween("d", arcTween);
}

//get data
d3.json("sunburst.json", function(error, root) {

  path = svg.datum(root).selectAll("path")
      .data(partition.nodes)
    .enter().append("path")
      .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
      .attr("d", arc)
      .style("stroke", "#fff")
      .style("fill", function(d) { return getArcColor(d.name); })
      .style("fill-rule", "evenodd")
      .on("click",function(d,i){alert(d.name)})
      .each(stash);

});

// Stash the old values for transition.
function stash(d) {
  d.x0 = d.x;
  d.dx0 = d.dx;
}

// Interpolate the arcs in data space.
function arcTween(a) {
  var i = d3.interpolate({x: a.x0, dx: a.dx0}, a);
  return function(t) {
    var b = i(t);
    a.x0 = b.x;
    a.dx0 = b.dx;
    return arc(b);
  };
}

//ghetto color selector
function getArcColor(n){
  switch(n){
    case "For":
      return "#1E30FF";
    case "ForAgreed":
      return "#111774";
    case "ForDisagreed":
      return "#6670E8"; //3695ae
    case "Against":
      return "#ff0000";
    case "AgainstAgreed":
      return "#8B0000";
    case "AgainstDisagreed":
      return "#EE6363"; //FF6B6B
    case "Ambivalent":
      return "#c0c0c0";    
    case "AmbivalentAgreed":
      return "#615656";
    case "AmbivalentDisagreed":
      return "#a8bba8";
    default:
      return "#000";
  }
}
d3.select(self.frameElement).style("height", height + "px");