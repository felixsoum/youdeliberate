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
