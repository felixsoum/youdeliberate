#= require functions

describe "Category Color", ->
  it "is black by default", ->
    expect(getCategoryColor()).toBe("#000")
