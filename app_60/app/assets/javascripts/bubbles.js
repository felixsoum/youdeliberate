<!--Bubble generation : http://bl.ocks.org/mbostock/4063269-->

//var bubbleDataSource = "example3.json;" //data from stub with narratives grouped by category
//var bubbleDataSource = "example4.json"; //data from stub with randomly placed narratives
var bubbleDataSource = '/narratives.json'; //data from DB

var diameter = 0; //initialize global var

//draw bubbles 
function drawBubbles(){
	//delete all children in div 
	
	var node1 = document.getElementById("bubbles"); 
	while (node1.hasChildNodes()) {
		node1.removeChild(node1.lastChild);
	}	
	
	var diameter = $("#bubbles").width()
		format = d3.format(",d"),
		color = d3.scale.category20c();

	var bubble = d3.layout.pack()
		.sort(null)
		.size([$("#bubbles").width(), $("#bubbles").height()])
		.padding(4.5);
		
	var svg = d3.select("#bubbles").append("svg")
		.attr("width", $("#bubbles").width())
		.attr("height", $("#bubbles").height())
		.attr("class", "bubble");

	d3.json(bubbleDataSource, function(error, root) {
	 var node = svg.selectAll(".node")
		  .data(bubble.nodes(classes(root))
		  .filter(function(d) { return !d.children; }))
		  .enter().append("g")
		  .attr("class", "node");  

	//title appears on mouseover
	//node.append("title")
	//  .text(function(d) { return d.className + ": " + format(d.value); });

	  node.append("circle")
			.attr("r",function(d) {
		  	 return d.r/2; 
		  	 })		
		  .style("fill", function(d) { return "#FFF" })
		  .style("stroke","#FFF")
		  .attr("transform", function(d) { return "translate(" + 200 + "," + 200 + ")"; })
		  //For fill-in selection color
		  //.on("mouseover",function(d){d3.select(this).style("fill",function(d) { return getMouseOverColor(d.category); })})
		  //.on("mouseout",function(d){d3.select(this).style("fill" function(d) { return getCategoryColor(d.category); })})
		  //For outline selection color
		  .on("mouseover",function(d){d3.select(this).style("stroke",function(d) { d3.select(this).style("opacity",0.5); return getMouseOverColor(d.category);  })})
		  .on("mouseout",function(d){d3.select(this).style("stroke", function(d) { d3.select(this).style("opacity",1); return getCategoryColor(d.category);  })})
		  .on("click",function(d){$.fancybox({type: 'iframe',href: Routes.play_narrative_path(d.n_id)});}) //Requests single-narrative view with appropriate ID
		  .transition()
		  .attr("r", function(d) {
		  	 return d.r; 
		  	 })
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .style("fill", function(d) { return getCategoryColor(d.category); })
		  .style({ 'stroke': function(d) { return getCategoryColor(d.category); }, 'stroke-width': '3px'})
		  .style("opacity",1)
		  .duration(3000)
		  .ease("bounce");

	  //Text on bubbles
	  /*
	  node.append("text")
		  .attr("dy", ".3em")
		  .style("text-anchor", "middle")
		  .style("opacity",0)
		  .attr("transform", function(d) { return "translate(" + 200 + "," + 200 + ")"; })
		  .text(function(d) { return d.className.substring(0,  d.r/ 3)})
		  .transition()
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .style("opacity",1)
		  .duration(2000)
		  .ease("bounce");
	  */
			
	});		
}

// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
  var classes = [];

  function recurse(name, node) {
    if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
    else classes.push({packageName: name, className: node.name, value: node.size, agree : node.NumberAgree, disagree: node.NumberDisagree, views: node.NumberViews, category: node.category, n_id: node.id });
  }

  recurse(null, root);
  return {children: classes};
}

function getMouseOverColor(n){
	//return "#aaa"	   //Grey
	//return "#4CBB17" //Kelly Green
	return "#FFF";     //White
}

//d3.select(self.frameElement).style("height", diameter + "px");  //I have no idea what this does

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    drawBubbles();
};

$(document).ready(init);
$(document).on('page:load', init);