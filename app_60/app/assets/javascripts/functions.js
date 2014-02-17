function sortClassToggle(b){
  if ( b.className.match(/(?:^|\s)btn-default(?!\S)/) ){
    $(".sort-select").removeClass("btn-primary").addClass("btn-default");
    b.className = "btn btn-primary btn-lg sort-select";
  }
  else {b.className = "btn btn-default btn-lg sort-select";}
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