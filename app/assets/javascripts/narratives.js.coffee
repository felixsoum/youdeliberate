# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Unobtrusive JavaScript: http://guides.rubyonrails.org/working_with_javascript_in_rails.html

window.playNarrative = (id) ->
  $.fancybox({type: 'iframe', href: Routes.play_narrative_path(id)})

$ ->
  $("a[data-narrative-id]").click (e) ->
    e.preventDefault()
 
    narrativeId = $(this).data("narrative-id")
    window.playNarrative(narrativeId)

jQuery ->
  $("table").tablesorter
    theme: "blue"
    textExtraction:
      0: (node) ->
        $(node).find("input").val()
      1: (node) ->
        $(node).find("option:selected").text()
      2: (node) ->
        $(node).find("option:selected").text()
    headers:
      8:
        sorter: false
      9:
        sorter: false
  return