// Sort button handler
function sortClassToggle(b){

  //Update button colors
  $(".sort-select").removeClass("btn-primary").addClass("btn-default");
  b.className = "btn btn-primary btn-lg sort-select";

  //Change sort criteria
  switch(b.id)
  {
    case "sort-by-views":
    currentSortCriteria = sortCriteria.SORTBYVIEWS;
    break;
    case "sort-by-agrees":
    currentSortCriteria = sortCriteria.SORTBYAGREES;
    break;
    case "sort-by-comments":
    currentSortCriteria = sortCriteria.SORTBYCOMMENTS;
    break;
    case "sort-by-time":
    currentSortCriteria = sortCriteria.SORTBYTIME;
    break;
  }

  //Redraw bubbles
  //drawBubbles();

  //Transition bubbles
  transitionBubbles();
}

//Filter by language handler
function filterLanguageToggle(b){

  //Update button colors
  $(".lang-select").removeClass("btn-primary").addClass("btn-default");
  b.className = "btn btn-primary btn-lg lang-select";

  //Change sort criteria
  switch(b.id)
  {
    case "filter-french":
    currentLanguageFilter = languageFilter.FRENCH;
    break;
    case "filter-english":
    currentLanguageFilter = languageFilter.ENGLISH;
    break;
    case "filter-bilingual":
    currentLanguageFilter = languageFilter.BILINGUAL;
    break;
  }

  //alert(b.id);

  //Update circle opacity
  d3.selectAll("circle").each(function(c,i){
    d3.select(this).transition().duration(1000).style("opacity",function(d){return getCircleOpacity(d)});
  });
}

function filterCategoryToggle(b){

  if(b == currentCategoryFilter.value){
    currentCategoryFilter = categoryFilter.ALL;
  }
  else{
    switch(b)
    {
      case 1:
      currentCategoryFilter = categoryFilter.FOR;
      break;
      case 2:
      currentCategoryFilter = categoryFilter.AGAINST;
      break;
      case 3:
      currentCategoryFilter = categoryFilter.AMBIVALENT;
      break;
    }
  }

  //Change sort criteria
  

  //alert(b.id);

  //Update circle opacity
  d3.selectAll("circle").each(function(c,i){
    d3.select(this).transition().duration(1000).style("opacity",function(d){return getCircleOpacity(d)});
  });
   d3.selectAll("path").each(function(c,i){
    d3.select(this).transition().duration(1000).style("opacity",function(d){return getSunburstSegmentOpacity(d)});
  });
}

function getCircleOpacity(c){
  if((c.language == currentLanguageFilter.value || currentLanguageFilter == languageFilter.BILINGUAL) && (c.category == currentCategoryFilter.value || currentCategoryFilter == categoryFilter.ALL)){
    return 1;  
  }
  else{
    return 0.3;
  }    
}


function getSunburstSegmentOpacity(d){
  if(d.category_id == currentCategoryFilter.value || currentCategoryFilter == categoryFilter.ALL){
    return 1;
  }
  else{
    return 0.3;
  }
    
}

function setSunburstSegmentOpacities(){
  //d3.selectAll
}


// 3 color design
function getCategoryColor(n){
  switch(n){
    case "For":
    case "ForNeutral":
    case "ForAgreed":
    case "ForDisagreed":
    case 1:
      //return "#4CBB17";  //Kelly Green
      //return "#1E30FF"   //Some Blue
      return "#428BCA"   //Bootstrap Blue
    case "Against":
    case "AgainstNeutral":
    case "AgainstAgreed":
    case "AgainstDisagreed":
    case 2:
      return "#ff0000";    //Red
    case "Ambivalent":
    case "AmbivalentNeutral":
    case "AmbivalentAgreed":
    case "AmbivalentDisagreed":
    case 3:
      return "#c0c0c0";   //Grey
    default:
      return "#000";
  }
}

function highlightMatchingSunburstSegment(c){
  d3.selectAll("path").filter(function(d){return d.category_id == c.attr("categoryID")}).transition().style("opacity",0.5);
  //d3.selectAll("path").filter(function(d){for (var name in d) {alert(name);}});
}


function deHighlightSunburstSegments(){
  //d3.selectAll("path").each{function(d){d.style("opacity",function(d){ return getSunburstSegmentOpacity(d);})}};
  d3.selectAll("path").each( function(d){d3.select(this).transition().style("opacity",getSunburstSegmentOpacity(d));});
}

function highlightMatchingCircles(d){

  d3.selectAll("circle").filter(function(c){return c.category == d.category_id}).transition().style("opacity",0.7).style("stroke",getMouseOverColor(d.category));

}

function deHighlightCircles(){

  d3.selectAll("circle").each( function(c){d3.select(this).transition().style("opacity",getCircleOpacity(c)).style("stroke",getCategoryColor(c.category));}  );

}


$(document).ready(function() {
  $(".fancybox").fancybox();
});


/* 9 color design
function getCategoryColor(n){
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
*/