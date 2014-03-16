#= require bubbles

describe "Bubbles Mouse Over Color", ->
  it "is white by default", ->
    expect(getMouseOverColor()).toBe("#FFF")

describe "Language Filter", ->
  it "is bilingual by default", ->
    expect(currentLanguageFilter).toBe(languageFilter.BILINGUAL)