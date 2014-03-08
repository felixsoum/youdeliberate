#= require bubbles
#= require functions

describe "Category Color", ->
  it "is black by default", ->
    expect(getCategoryColor()).toBe("#000")

describe "Circle Opacity", ->
  c =
    language: ""
    category: ""
  it "is greater than 0 by default", ->
    expect(getCircleOpacity(c)).toBeGreaterThan(0)

  c.language = currentLanguageFilter.value
  c.category = currentCategoryFilter.value
  it "is equal to 1 when part of the current filter", ->
    expect(getCircleOpacity(c)).toBe(1)
