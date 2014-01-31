function changeClass(b){
	if ( b.className.match(/(?:^|\s)btn-default(?!\S)/) ){b.className = "btn btn-success btn-lg";}
	else {b.className = "btn btn-default btn-lg";}
        
}

$(document).ready(function() 
{
   // Match all link elements with href attributes within the content div
   $('path').qtip({
   content: 'This is a sunburst segment',
   show: 'mouseover',
   hide: 'mouseout'
})
});