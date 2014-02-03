function changeClass(b){
	if ( b.className.match(/(?:^|\s)btn-default(?!\S)/) ){b.className = "btn btn-success btn-lg";}
	else {b.className = "btn btn-default btn-lg";}
        
}