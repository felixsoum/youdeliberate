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
    //.innerRadius(function(d) { return Math.sqrt(d.y); })
    .innerRadius(function(d) { return Math.sqrt(d.y / 1.5); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });
}

//load animation
function onLoadAnim() {
  var value = function(d) { return d.size; };
    
    path
        .data(partition.value(value).nodes)
      .transition()
        .duration(3000)
        //.delay(1000)
        .attrTween("d", arcTween);
}

//get data
function getData() {
  d3.json("sunburst3.json", function(error, root) {
    path = svg.datum(root).selectAll("path")
        .data(partition.nodes)
      .enter().append("path")
        .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
        .attr("d", arc)
        .style("opacity",1.0)
        .style("stroke", "#fff")
        .style("fill", function(d) { return getCategoryColor(d.name); })
        .style("fill-rule", "evenodd")
        .on("mouseover",function(d){d3.select(this).style("stroke",function(d) { d3.select(this).style("opacity",0.5); return getArcMouseOutColor(d.category);  })})
        .on("mouseout",function(d){d3.select(this).style("stroke", function(d) { d3.select(this).style("opacity",1); return getArcMouseOutColor(d.category);  })})
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

function getArcMouseOverColor(n){
  //return "#aaa"    //Grey
  //return "#4CBB17" //Kelly Green
  return "#000";
}

function getArcMouseOutColor(n){
  //return "#aaa"    //Grey
  //return "#4CBB17" //Kelly Green
  return "#fff";
}
d3.select(self.frameElement).style("height", height + "px");

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    setArc();
    getData();
};

$(document).ready(init);
$(document).on('page:load', init);