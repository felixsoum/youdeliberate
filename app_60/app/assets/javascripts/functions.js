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

function getCircleOpacity(c){
  if((c.language == currentLanguageFilter.value || currentLanguageFilter == languageFilter.BILINGUAL) && (c.category == currentCategoryFilter.value || currentCategoryFilter == categoryFilter.ALL)){
    return 1;  
  }
  else{
    return 0.1;
  }    
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