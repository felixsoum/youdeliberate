//= require functions

// I don't know where to stop, since coverage tool not set up at this time (istanbul tool)
describe("Jignesh - Circle Opacity 1", function(){
   
    var c, languageFilter, categoryFilter;
    var fncReturn;
    
    var languageFilter = {
	ENGLISH : {value: 1, name: "English", code: "E"},
	FRENCH: {value: 2, name: "Francais", code: "F"},
	BILINGUAL: {value: 3, name: "Bilingual", code: "B"}}
    
    var categoryFilter = {
	FOR : {value: 1, name: "For", code: "F"},
	AGAINST : {value: 2, name: "Against", code: "AG"},
	AMBIVALENT: {value: 3, name: "Ambivalent", code: "AM"},
	ALL: {value: 4, name: "All", code: "AL"}}
    
    beforeEach(function(){//can initialize the following variables to several values to pass/fail test
        c = {language:3,category:4};
                     
        currentCategoryFilter = categoryFilter.ALL;
        currentLanguageFilter = languageFilter.BILINGUAL;
        
    });
    
    it("calls the method", function(){
        fncReturn = getCircleOpacity(c);
    });
    
    it("must return value that changes opacities", function(){
        expect(fncReturn).toEqual(1);
    });
});

describe("Jignesh - Circle Opacity 2", function(){
   
    var c;
    var languageFilter, categoryFilter;
    var fncReturn;
    
    var languageFilter = {
	ENGLISH : {value: 1, name: "English", code: "E"},
	FRENCH: {value: 2, name: "Francais", code: "F"},
	BILINGUAL: {value: 3, name: "Bilingual", code: "B"}}
    
    var categoryFilter = {
	FOR : {value: 1, name: "For", code: "F"},
	//AGAINST : {value: 2, name: "Against", code: "AG"},
	AMBIVALENT: {value: 3, name: "Ambivalent", code: "AM"},
	ALL: {value: 4, name: "All", code: "AL"}}
    
    beforeEach(function(){//can initialize the following variables to several values to pass/fail test
        c = {language:3,category:4};
                     
        currentCategoryFilter = categoryFilter.FOR;
        currentLanguageFilter = languageFilter.BILINGUAL;
        
    });
    
    it("calls the method", function(){
        fncReturn = getCircleOpacity(c);
    });
    
    it("must not change opacities", function(){
        expect(fncReturn).toEqual(0.2);
    });
});


describe("Sunburst Opacity", function(){
    var a,d;
    var currentCategoryFilter;
    
    var categoryFilter = {
	FOR : {value: 1, name: "For", code: "F"},
	AGAINST : {value: 2, name: "Against", code: "AG"},
	AMBIVALENT: {value: 3, name: "Ambivalent", code: "AM"},
	ALL: {value: 4, name: "All", code: "AL"}}
    
beforeEach(function(){    
    d = {category_id: 4};
    currentCategoryFilter = categoryFilter.ALL;
});

it("calls function", function(){
    a = getSunburstSegmentOpacity(d);
});

it("will dim the Sunburst", function(){           
    expect(a).toEqual(0.2);
});
    
});


/*
describe("Sunburst Opacity", function(){
    var a, d;
    var currentCategoryFilter;
    
    var categoryFilter = {
	FOR : {value: 1, name: "For", code: "F"},
	AGAINST : {value: 2, name: "Against", code: "AG"},
	AMBIVALENT: {value: 3, name: "Ambivalent", code: "AM"},
	ALL: {value: 4, name: "All", code: "AL"}
}
    
beforeEach(function(){    
    d = {category_id:2};
    currentCategoryFilter = categoryFilter.ALL; 
});
    
it("calls the method", function(){
    a = getSunburstSegmentOpacity(d);
});

it("will not dim the Sunburst", function(){           
    expect(a).toEqual(0.2);
});
    
});
*/