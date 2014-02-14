<!--Bubble generation : http://bl.ocks.org/mbostock/4063269-->
var fileName = "example2.json";   //data from stub
fileName = 'http://localhost:3000/narratives.json'; //data from DB
var radius = 100; 
//test to see if dummy objects work and filtering 
function OnCheckFilterOption(){	
	var forValue = document.getElementById("for").checked; 
	var againstValue = document.getElementById("against").checked;
	var ambValue = document.getElementById("amb").checked; 
	
	if(forValue == true && againstValue == true && ambValue == true){
		fileName = "flare.json"; 
	}
	if(forValue == true && againstValue == false && ambValue == false){
		fileName = "for.json"; 
	}
	if(forValue == false && againstValue == true && ambValue == false){
		fileName = "against.json"; 
	}
	if(forValue == false && againstValue == false && ambValue == true){
		fileName = "ambivalent.json"; 
	}
	if(forValue == true && againstValue == true && ambValue == false){
		fileName = ".forAgainst.json"; 
	}
	if(forValue == true && againstValue == false && ambValue == true){
		fileName = "AmbivalentFor.json"; 
	}
	if(forValue == false && againstValue == true && ambValue == true){
		fileName = "ambivalentAgainst.json"; 
	}
	refreshBubbles(); 
}
//call for testing perpuses 
var diameter = 0; 
function refreshBubbles(){
	//delete all children in div 
	
	var node1 = document.getElementById("bubbles"); 
	while (node1.hasChildNodes()) {
		node1.removeChild(node1.lastChild);
	}	
	
	diameter = 500,
		format = d3.format(",d"),
		color = d3.scale.category20c();


	var bubble = d3.layout.pack()
		.sort(null)
		.size([diameter, diameter])
		.padding(4.5);
		
	var svg = d3.select("#bubbles").append("svg")
		.attr("width", diameter*2)
		.attr("height", diameter)
		.attr("class", "bubble");

	d3.json(fileName, function(error, root) {
	 var node = svg.selectAll(".node")
		  .data(bubble.nodes(classes(root))
		  .filter(function(d) { return !d.children; }))
		  .enter().append("g")
		  .attr("class", "node");  

	  node.append("title")
		  .text(function(d) { return d.className + ": " + format(d.value); });

	  node.append("circle")
			.attr("r",function(d) {
		  	 return d.r/2; 
		  	 })		
		  .attr("transform", function(d) { return "translate(" + 200 + "," + 200 + ")"; })
		  .style({ 'stroke': function(d) { return getSectionColor(d.category); }, 'fill': 'none', 'stroke-width': '3px'})
		  //For fill-in selection color
		  //.on("mouseover",function(d){d3.select(this).style("fill",function(d) { return getMouseOverColor(d.category); })})
		  //.on("mouseout",function(d){d3.select(this).style("fill", function(d) { return getSectionColor(d.category); })})
		  //For outline selection color
		  .on("mouseover",function(d){d3.select(this).style("stroke",function(d) { d3.select(this).style("opacity",1); return getMouseOverColor(d.category);  })})
		  .on("mouseout",function(d){d3.select(this).style("stroke", function(d) { d3.select(this).style("opacity",0.75); return getSectionColor(d.category);  })})
		  .on("click",function(d){$.fancybox({type: 'iframe',href: 'http://localhost:3000/narratives/play/'+d.n_id});}) //Requests single-narrative view with appropriate ID
		  .transition()
		  .attr("r", function(d) {
		  	 return d.r; 
		  	 })
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
		  .style("fill", function(d) { return getSectionColor(d.category); })
		  .style("opacity",0.75)
		  .duration(2000)
		  .ease("bounce");

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

//use for testing sorting 
function getSize(d){ 
	if(document.getElementById('recent').checked) {
		radius = d.value; 
		return radius; 
	}else if(document.getElementById('agreed').checked) {
		radius = d.agree; 
		return radius; 
	}
	else if(document.getElementById('disagreed').checked) {
		radius = d.disagree; 
		return radius; 
	}
	else if(document.getElementById('viewed').checked) {
		radius = d.views; 
		return radius; 
	}
	else{
		radius = d.value; 
		return radius; 
	}
}
function getSectionColor(n){

	switch(n){
    case "For":
    case "ForNeutral":
    case 0:
      return "#1E30FF";
    case "ForAgreed":
      return "#111774";
    case "ForDisagreed":
      return "#6670E8"; //3695ae
    case "Against":
    case "AgainstNeutral":
    case 1:
      return "#ff0000";
    case "AgainstAgreed":
      return "#8B0000";
    case "AgainstDisagreed":
      return "#EE6363"; //FF6B6B
    case "Ambivalent":
    case "AmbivalentNeutral":
    case 2:
      return "#c0c0c0";    
    case "AmbivalentAgreed":
      return "#615656";
    case "AmbivalentDisagreed":
      return "#a8bba8";
    default:
      return "#000";
  }
}
function getMouseOverColor(n){
	//return "#aaa"	   //Grey
	//return "#4CBB17" //Kelly Green
	return "#000";
}
d3.select(self.frameElement).style("height", diameter + "px");

// jQuery.ready() with turbolinks. Read more: http://stackoverflow.com/a/17600195
var init = function() {
    refreshBubbles();
};

$(document).ready(init);
$(document).on('page:load', init);