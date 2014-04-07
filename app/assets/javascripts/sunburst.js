//specify sunburst size
var width = 300,
    height = 300,
    radius = Math.min(width, height) / 2;

//apologies to anyone reading this, here's a bunch of global vars
var svg;
var partition;
var arc;
var path; 
var categoryCount = {};
var categoryPercentages = {};
var forDiv;
var againstDiv;
var ambivalentDiv;

function setArc() {
    //add element to document body
    svg = d3.select("#sunburst").append("svg")
      .attr("width", width)
      .attr("height", height+10)
      .attr("id", "sunburst-svg")
      .append("g")
      .attr("transform", "translate(" + width / 2 + "," + height * .52 + ")")

    //d3 layout magic
    partition = d3.layout.partition()
    .sort(null)
    .size([2 * Math.PI, radius * radius])
    .value(function(d) { return d; }); // return 1 for previous animation style

    arc = d3.svg.arc()
    .startAngle(function(d) { return d.x; })
    .endAngle(function(d) { return d.x + d.dx; })
    .innerRadius(function(d) { return Math.sqrt(d.y / 1.5); })
    .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });
}

//load animation
function onLoadAnim() {
  var value = function(d) { return d.count; };
    
    path
        .data(partition.value(value).nodes)
        .transition()
        .duration(2700)
        .attrTween("d", arcTween);
initializeTooltips(); 
  
}
function initializeTooltips(){
  jQuery('#toolTip1').tooltip({html:true,placement:'bottom',trigger:'manual',html:true}); 
  jQuery('#toolTip2').tooltip({html:true,placement:'bottom',trigger:'manual',html:true});
  jQuery('#toolTip3').tooltip({html:true,placement:'bottom',trigger:'manual',html:true}); 
}
//get data
function getData() {

  createTooltipDivs(); 
  d3.json("/sunburst.json", function(error, root) {

    path = svg.datum(root).selectAll("path")
        .data(partition.nodes)
        .enter().append("path")
        .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
        .attr("d", arc)
        .attr("categoryID",function(d){ populateCategoryCount(d.category_id, d.count); return d.category_id; }) //populate category percentages here for some reason
        .attr("class","sunburst-path")
        .attr("id",function(d){return "category"+d.category_id})
        .attr("data-toggle","tooltip")
        .style("opacity",function(d){ return getSunburstSegmentOpacity(d); })
        .style("stroke", function(d) { return getArcMouseOutColor(d.category_id); })
        .style("stroke-width","2px")
        .style("fill", function(d) { return getCategoryColor(d.category_id); })
        .style("fill-rule", "evenodd")
        .on("mouseover",function(d){d3.select(this).style("stroke",function(d) { d3.select(this).style("opacity",0.5); highlightMatchingCircles(d); showTooltip(d); return getArcMouseOverColor(d.category_id);  })})
        .on("mouseout",function(d){d3.select(this).style("stroke", function(d) { d3.select(this).style("opacity",function(d){ return getSunburstSegmentOpacity(d); }); deHighlightCircles(); hideTooltip(d); return getArcMouseOutColor(d.category_id);  })})
        .on("click",function(d,i){filterCategoryToggle(d.category_id)})
        .each(stash);
        
        populateCategoryPercentages();

        // Only animate after D3 is done to avoid a race condition
        onLoadAnim();
  });
}



function populateCategoryCount(i,c){
  categoryCount[i] = c == NaN ? 0 : c;
}
//behold the magic numbers
function populateCategoryPercentages(){
  var categoryCountLength = 4;
  var total = 0;
  for(i=0;i<categoryCountLength;i++){
    if(parseInt(categoryCount[i], 10) > 0){
      total += categoryCount[i];
    }
  }

  for(i=0;i<categoryCountLength;i++){
    if(parseInt(categoryCount[i], 10) > 0){    
      categoryPercentages[i] = parseInt((categoryCount[i] / total * 100).toPrecision(3));
    }
    else{
      categoryPercentages[i] = 0;
    }
  }
  //Hardcoded tooltips. Should generate these more dynamically in "future releases"
  forDiv.title = "POUR <span class='glyphicon glyphicon-flash'></span> FOR</br> "+categoryPercentages[1]+"%";
  againstDiv.title = "CONTRE <span class='glyphicon glyphicon-flash'></span></br> AGAINST</br> "+categoryPercentages[2]+"%";
  ambivalentDiv.title = "AMBIVALENT(E) <span class='glyphicon glyphicon-flash'></span></br> AMBIVALENT</br> "+categoryPercentages[3]+"%";
}

//Hardcoded tooltips. Should generate these more dynamically in "future releases"
function createTooltipDivs(){
  var foo = document.getElementById('sunburst');
  var top = jQuery("#sunburst-svg").offset().top; 
  var left = jQuery("#sunburst-svg").offset().left; 
  var height = $(document.getElementById('sunburst-svg')).height();
  var newTop = top +height/2.5; 
  var newLeft = left + width/2; 
  
  //create tooltip div for "For" category 
  forDiv = document.createElement('div'); 
  forDiv.id = "toolTip1"; 
  forDiv.style.width = "5px"; 
  forDiv.style.height = "5px"; 
  forDiv.innerHTML = ""; 
  forDiv.title = "POUR <span class='glyphicon glyphicon-flash'></span> FOR</br> "+categoryPercentages[1]+"%"; 
  foo.appendChild(forDiv); 
  jQuery("#toolTip1").offset({top:newTop,left:newLeft});
  jQuery('#toolTip1').attr("data-toggle","tooltip"); 

  //create tooltip div for "Against" category 
  againstDiv = document.createElement('div'); 
  againstDiv.id = "toolTip2"; 
  againstDiv.style.width = "1px"; 
  againstDiv.style.height = "1px"; 
  againstDiv.innerHTML = ""; 
  againstDiv.title = "CONTRE <span class='glyphicon glyphicon-flash'></span></br> AGAINST</br> "+categoryPercentages[2]+"%"; 
  foo.appendChild(againstDiv); 
  jQuery("#toolTip2").offset({top:newTop,left:newLeft});
  jQuery('#toolTip2').attr("data-toggle","tooltip"); 

  //create tooltip div for "Ambivalent" category 
  ambivalentDiv = document.createElement('div'); 
  ambivalentDiv.id = "toolTip3"; 
  ambivalentDiv.style.width = "1px"; 
  ambivalentDiv.style.height = "1px"; 
  ambivalentDiv.innerHTML = ""; 
  ambivalentDiv.title = "AMBIVALENT(E) <span class='glyphicon glyphicon-flash'></span></br> AMBIVALENT</br> "+categoryPercentages[3]+"%"; 
  foo.appendChild(ambivalentDiv); 
  jQuery("#toolTip3").offset({top:newTop,left:newLeft});
  jQuery('#toolTip3').attr("data-toggle","tooltip"); 

}
function showTooltip(d){  
  var id = "#toolTip"+d.category_id; 
  jQuery(id).tooltip('show'); 
}
function hideTooltip(d){
  var id = "#toolTip"+d.category_id; 
  jQuery(id).tooltip('hide');
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
  return "#fff";
}

function getArcMouseOutColor(n){
  //return "#aaa"    //Grey
  //return "#4CBB17" //Kelly Green
  return "#fff"
}
//d3.select(self.frameElement).style("height", height + "px");

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    setArc();
    getData();
};

$(document).ready(init);
$(document).on('page:load', init);