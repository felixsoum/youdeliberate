//= require functions


describe("Sunburst Opacity", function(){
    var a;
    var d;
    
beforeEach(function(){    
    d = {category_id:23, };
    a = getSunburstSegmentOpacity(d);
});

it("must return 0.1", function(){           
    expect(a).toEqual(1);
});
    
});

describe("Circle Opacity", function(){
   
    var c;
    var languageFilter, categoryFilter;
    var fncReturn;
    
    beforeEach(function(){
        c = {language:2,category:2};
                     
        categoryFilter = {ALL:1};
        languageFilter = {BILINGUAL:1};
        
    });
    
    it("calls the method", function(){
        fncReturn = getCircleOpacity(c);
    });
    
    it("must return opacities", function(){
        expect(fncReturn).toEqual(1);
    });
});



describe("functions is being tested", function(){
   var test;
    it("not of value", function(){
       test = getCategoryColor(3);    
       expect(test).toEqual("#A0A0A0");
        
    });
});