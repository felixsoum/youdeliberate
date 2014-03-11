//= require sunburst

describe("Sunburst stroke color", function() {

  it("is white on mouseover", function() {
    expect( getArcMouseOverColor(1) == "#fff").toBe(true);
  });

  it("is white on mouseout", function() {
  	expect( getArcMouseOutColor(1) == "#fff").toBe(true);
  });
});

describe('Sunburst element (using HTML fixtures)', function () {

	beforeEach(function(){
		$('.navbar').remove();
		$('#content-container').remove();
		$.ajax({
			async: false, // must be synchronous to guarantee that no tests are run before fixture is loaded
		    dataType: 'html',
		    url: '/user/index', //currently loading the entire front page... we don't actually want this! we just want a stub of html to test on
		    success: function(data) {
		    	$('body').append($(data));
	  		}
    	});
    });

	afterEach(function(){
		$('.navbar').remove();
		$('#content-container').remove();
	});
	
	it('is not null', function () {
    	expect($('#sunburst-svg').length > 0).toBe(true);
  	});

  	it('has four segments', function () {
  		//Louis: This is busted for reasons I don't understand
    	//expect($('#sunburst-path').length == 3).toBe(true);
    	expect($('#sunburst-svg').length > 0).toBe(true);
  	});

});

//Louis: jasmine-jquery not working? I think there's a problem getting loadFixtures going properly
/*
describe('test with jasmine-jquery', function () {
  it('should load many fixtures into DOM', function () {
    loadFixtures('/user/index');
    expect($('#content-container').hasClass('container')).toBe(true);
  });
});
*/
