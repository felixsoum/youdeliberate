<!--Bubble generation : http://bl.ocks.org/mbostock/4063269-->

//var bubbleDataSource = "example3.json;" //data from stub with narratives grouped by category
//var bubbleDataSource = "example4.json"; //data from stub with randomly placed narratives
var bubbleDataSource = '/narratives.json'; //data from DB

var diameter = 0; //initialize global var
var bubble; //lord help us global variables

//Define sort criteria
var sortCriteria = {
	SORTBYAGREES : {value: 0, name: "Sort by agrees", code: "A"}, 
	SORTBYVIEWS: {value: 1, name: "Sort by views", code: "V"}, 
	SORTBYCOMMENTS : {value: 2, name: "Sort by comments", code: "C"},
	SORTBYTIME : {value: 3, name: "Sort by time uploaded", code: "T"}
};

var currentSortCriteria = sortCriteria.SORTBYVIEWS;

//Define narrative language filters
var languageFilter = {
	ENGLISH : {value: 1, name: "English", code: "E"},
	FRENCH: {value: 2, name: "Francais", code: "F"},
	BILINGUAL: {value: 3, name: "Bilingual", code: "B"}
}

var currentLanguageFilter = languageFilter.BILINGUAL;

//Define narrative category filters
//Categories are currently hardcoded. TODO: Get categories dynamically
var categoryFilter = {
	FOR : {value: 1, name: "For", code: "F"},
	AGAINST : {value: 2, name: "Against", code: "AG"},
	AMBIVALENT: {value: 3, name: "Ambivalent", code: "AM"},
	ALL: {value: 4, name: "All", code: "AL"}
}

var currentCategoryFilter = categoryFilter.ALL;

//draw bubbles 
function drawBubbles(){
	//delete all children in div 
	
	var node1 = document.getElementById("bubbles"); 
	while (node1.hasChildNodes()) {
		node1.removeChild(node1.lastChild);
	}	
	
	var diameter = $("#bubble-inner-panel").width()
		format = d3.format(",d"),
		color = d3.scale.category20c();

	bubble = d3.layout.pack()
		.sort(null)
		.size([diameter, $("#bubble-inner-panel").height()])
		.padding(4.5);
		
	var svg = d3.select("#bubbles").append("svg")
		.attr("width", diameter)
		.attr("height", $("#bubble-inner-panel").height())
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
		  .attr("languageID", function(d){return d.language; })
		  .attr("categoryID", function(d){return d.category; })
		  .attr("transform", function(d){ return "translate(" + 200 + "," + 200 + ")"; })
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
		  .style("opacity",function(d){return getCircleOpacity(d)})
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

function transitionBubbles(){

	d3.json(bubbleDataSource, function(error, root) {

	  d3.selectAll("circle")
	  	.data(bubble.nodes(classes(root))
	  	.filter(function(d) { return !d.children; }))			
		  .transition()
		  .attr("r", function(d) {
		  	 return d.r; 
		  	 })
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .duration(1000)

	});	
}

// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
  var classes = [];

  function recurse(name, node) {
    if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
    else classes.push({packageName: name, className: node.name, value: getValueBySortCriteria(node), agree : node.numberAgree, disagree: node.numberDisagree, views: node.numberViews, category: node.category, n_id: node.id, language: node.language });
  }

  recurse(null, root);
  return {children: classes};
}

function getValueBySortCriteria(n){
	//Define size of bubbles with criteria value 0
	var minimumCircleSize = 0.1; 
	switch(currentSortCriteria)
	{
		case sortCriteria.SORTBYVIEWS:
		return n.numberViews == 0 ? minimumCircleSize : n.numberViews;
		break;
		case sortCriteria.SORTBYCOMMENTS:
		return n.numberComments == 0 ? minimumCircleSize : n.numberComments;
		break;
		case sortCriteria.SORTBYTIME:
		var date = new Date(n.uploadTime);
		return date.getTime() == 0 ? minimumCircleSize : date.getTime();
		break;
		case sortCriteria.SORTBYAGREES:
		return n.numberAgree == 0 ? minimumCircleSize : n.numberAgree;
		break;
		default:
		return n.numberViews == 0 ? minimumCircleSize : n.numberViews;
	}
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