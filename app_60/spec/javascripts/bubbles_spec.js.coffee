#= require bubbles

describe "Mouse Over Color", ->
  it "is white by default", ->
    expect(getMouseOverColor()).toBe("#FFF")
