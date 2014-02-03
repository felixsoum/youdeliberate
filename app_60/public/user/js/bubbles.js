<!--Bubble generation : http://bl.ocks.org/mbostock/4063269-->
var fileName = "example2.json";   //default
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
		.padding(1.5);

	var svg = d3.select("#bubbles").append("svg")
		.attr("width", diameter*2)
		.attr("height", diameter)
		.attr("class", "bubble");

	d3.json(fileName, function(error, root) {
	  var node = svg.selectAll(".node")
		  .data(bubble.nodes(classes(root))
		  .filter(function(d) { return !d.children; }))
		.enter().append("g")
		  .attr("class", "node")
		  .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

	  node.append("title")
		  .text(function(d) { return d.className + ": " + format(d.value); });

	  node.append("circle")
		  .attr("r", function(d) { return d.r; })
		  .style("fill", function(d) { return getSectionColor(d.category); })
		  .on("mouseover",function(d){d3.select(this).style("fill",function(d) { return getMouseOverColor(d.category); })})
		  .on("mouseout",function(d){d3.select(this).style("fill", function(d) { return getSectionColor(d.category); })});

	  node.append("text")
		  .attr("dy", ".3em")
		  .style("text-anchor", "middle")
		  .text(function(d) { return d.className.substring(0,  d.r/ 3); });
	});
}

// Returns a flattened hierarchy containing all leaf nodes under the root.
function classes(root) {
  var classes = [];

  function recurse(name, node) {
    if (node.children) node.children.forEach(function(child) { recurse(node.name, child); });
    else classes.push({packageName: name, className: node.name, value: node.size, agree : node.NumberAgree, disagree: node.NumberDisagree, views: node.NumberViews, category: node.category });
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
	/*
	switch(n){
		case "For":
			return "#00CC33";
			break; 
		case "Against":
			return "#D80000";
			break; 
		case "Ambivalent":
			return "#D8D8D8";
			break; 
	}
	*/

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
function getMouseOverColor(n){
	return "#aaa"	
}
d3.select(self.frameElement).style("height", diameter + "px");

refreshBubbles(); <!-- INITIALIZE -->