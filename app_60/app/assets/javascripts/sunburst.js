//specify sunburst size
var width = 300, //420
    height = 300,//350
    radius = Math.min(width, height) / 2;

var svg;
var partition;
var arc;
var path; //for visibility. Might not be necessary

function setArc() {
    //add element to document body
    svg = d3.select("#sunburst").append("svg")
      .attr("width", width)
      .attr("height", height+10)
    .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height * .52 + ")");

    //d3 layout magic
    partition = d3.layout.partition()
    .sort(null)
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return 1; });

    arc = d3.svg.arc()
    .startAngle(function(d) { return d.x; })
    .endAngle(function(d) { return d.x + d.dx; })
    .innerRadius(function(d) { return Math.sqrt(d.y); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });
}

//load animation
function onLoadAnim() {
  var value = function(d) { return d.size; };
    
    path
        .data(partition.value(value).nodes)
      .transition()
        .duration(5000)
        .delay(1000)
        .attrTween("d", arcTween);
}

//get data
function getData() {
  d3.json("sunburst2.json", function(error, root) {
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

        // Only animate after D3 is done to avoid a race condition
        onLoadAnim();
  });
}

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
    case "ForNeutral":
      return "#1E30FF";
    case "ForAgreed":
      return "#111774";
    case "ForDisagreed":
      return "#6670E8"; //3695ae
    case "Against":
    case "AgainstNeutral":
      return "#ff0000";
    case "AgainstAgreed":
      return "#8B0000";
    case "AgainstDisagreed":
      return "#EE6363"; //FF6B6B
    case "Ambivalent":
    case "AmbivalentNeutral":
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

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    setArc();
    getData();
};

$(document).ready(init);
$(document).on('page:load', init);