<!--Bubble generation : http://bl.ocks.org/mbostock/4063269-->

var bubbleDataSource = '/narratives.json'; //data from DB

var diameter = 0; //initialize global var
var dateHash = {}; //I have no idea what I'm doing
var bubble; //lord help us, more global variables

//Define sort criteria
var sortCriteria = {
	SORTBYAGREES : {value: 0, name: "Sort by agrees", code: "A"},
	SORTBYDISAGREES : {value: 4, name: "Sort by disagrees", code: "D" },
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

	  node.append("circle")
			.attr("r",function(d) {
		  	 return d.r/2; 
		  	 })		
		  .style("fill", function(d) { return "#FFF" })
		  .style("stroke","#FFF")
		  .attr("languageID", function(d){return d.language; })
		  .attr("categoryID", function(d){return d.category; })
		  .attr("transform", function(d){ return "translate(" + 200 + "," + 200 + ")"; })
		  .attr("id",function(d){return "narrative"+d.n_id})
		  .attr("viewed","false")
		  .on("mouseover",function(d){d3.select(this).style("stroke",function(d) { d3.select(this).style("opacity",0.5); highlightMatchingSunburstSegment(d3.select(this)); return getMouseOverColor(d.category);  })})
		  .on("mouseout",function(d){d3.select(this).style("stroke", function(d) { d3.select(this).style("opacity",1); deHighlightSunburstSegments(); return getBubbleStrokeColor(this.getAttribute("viewed"),d.category);  })})
		  .on("click",function(d){$.fancybox({type: 'iframe',href: Routes.play_narrative_path(d.n_id)}); this.setAttribute("viewed","true"); d3.select(this).style("stroke",function(d){return getBubbleStrokeColor(this.getAttribute("viewed"),d.category);})}) //Requests single-narrative view with appropriate ID
		  .transition()
		  .attr("r", function(d) {
		  	 return d.r; 
		  	 })
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .style("fill", function(d) { return getCategoryColor(d.category); })
		  .style({ 'stroke': function(d) { return getBubbleStrokeColor(this.getAttribute("viewed"),d.category); }, 'stroke-width': '3px'})
		  .style("opacity",function(d){return getCircleOpacity(d)})
		  .duration(3000)
		  .ease("bounce");

	  //Text on bubbles
	  
	  node.append("text")
		  .attr("dy", ".3em")
		  .style("text-anchor", "middle")
		  .style("opacity",0)
		  .attr("transform", function(d) { return "translate(" + 200 + "," + 200 + ")"; })
		  .text(function(d) { return d.className.substring(0,  d.r/ 3)})
		  .transition()
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .style("opacity",1)
		  .duration(3000)
		  .ease("bounce");
	  
			
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
		  .duration(1000);

	d3.selectAll("text")
	.data(bubble.nodes(classes(root))
	  	.filter(function(d) { return !d.children; }))
		.transition()
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .duration(1000);
	});	
}

// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
  var classes = [];

  function recurse(name, node) {
    if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
    else classes.push({packageName: name, className: node.name, value: getValueBySortCriteria(node), agree : node.numberAgree, disagree: node.numberDisagree, views: node.numberViews, category: node.category, n_id: node.narrativeID, date: node.uploadTime, language: node.language });
  }

  recurse(null, root);
  populateDateHash(classes);
  return {children: classes};
}

function populateDateHash(c){

	var dates = [];
	var date;
	for(i=0; i<c.length; i++){
		date = new Date(c[i].date);
		dates.push(date.getTime());
	}
	dates.sort(function(a,b){return a-b});
	for(i=0; i<dates.length; i++){
		dateHash[dates[i]]=i+1; //We want our smallest narrative, when sorted by time uploaded, to have size 1, not 0
	}
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
		return date.getTime() == 0 ? minimumCircleSize : dateHash[date.getTime()] //UTC time values are really big, so we just sort them and give them size values 1, 2, 3, etc
		break;
		case sortCriteria.SORTBYAGREES:
		return n.numberAgree == 0 ? minimumCircleSize : n.numberAgree;
		break;
		case sortCriteria.SORTBYDISAGREES:
		return n.numberDisagree == 0 ? minimumCircleSize : n.numberDisagree;
		break;
		default:
		return n.numberViews == 0 ? minimumCircleSize : n.numberViews;
	}
}

function getBubbleStrokeColor(v,d){
	if(v=="true"){
		return "#663366";
	}
	else{
		return getCategoryColor(d);
	}
}

function getMouseOverColor(n){
	//return "#aaa"	   //Grey
	//return "#4CBB17" //Kelly Green
	return "#FFF";     //White
}

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    drawBubbles();
};

$(document).ready(init);
$(document).on('page:load', init);