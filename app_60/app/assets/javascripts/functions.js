function changeClass(b){
	if ( b.className.match(/(?:^|\s)btn-default(?!\S)/) ){b.className = "btn btn-success btn-lg";}
	else {b.className = "btn btn-default btn-lg";}
        
}

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