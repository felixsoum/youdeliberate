# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Unobtrusive JavaScript: http://guides.rubyonrails.org/working_with_javascript_in_rails.html

audioCount = 1
currentTrack = 1
leftmostTrack = 1
maxPagination = 5
paginationContainer =
"
░░░░░▄▄▄▄▀▀▀▀▀▀▀▀▄▄▄▄▄▄░░░░░░░
░░░░░█░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░▀▀▄░░░░
░░░░█░░░▒▒▒▒▒▒░░░░░░░░▒▒▒░░█░░░
░░░█░░░░░░▄██▀▄▄░░░░░▄▄▄░░░░█░░
░▄▀▒▄▄▄▒░█▀▀▀▀▄▄█░░░██▄▄█░░░░█░
█░▒█▒▄░▀▄▄▄▀░░░░░░░░█░░░▒▒▒▒▒░█
█░▒█░█▀▄▄░░░░░█▀░░░░▀▄░░▄▀▀▀▄▒█
░█░▀▄░█▄░█▀▄▄░▀░▀▀░▄▄▀░░░░█░░█░
░░█░░░▀▄▀█▄▄░█▀▀▀▄▄▄▄▀▀█▀██░█░░
░░░█░░░░██░░▀█▄▄▄█▄▄█▄████░█░░░
░░░░█░░░░▀▀▄░█░░░█░█▀██████░█░░
░░░░░▀▄░░░░░▀▀▄▄▄█▄█▄█▄█▄▀░░█░░
░░░░░░░▀▄▄░▒▒▒▒░░░░░░░░░░▒░░░█░
░░░░░░░░░░▀▀▄▄░▒▒▒▒▒▒▒▒▒▒░░░░█░
░░░░░░░░░░░░░░▀▄▄▄▄▄░░░░░░░░█░░
"

paginate = (n) ->
  switch n
    when '«'
      if leftmostTrack > 1
        leftmostTrack--
    when '»'
      if leftmostTrack < audioCount - maxPagination + 1
        leftmostTrack++
    else alert n

  paginationText = "<li id=\"pagination-control-left\"><a href=\"#\">«</a></li>"
  for index in [leftmostTrack..(leftmostTrack + maxPagination - 1)]
    paginationText += "<li"
    if index is currentTrack
      paginationText += " class=\"active\""
    paginationText += "><a href=\"#\">#{index}</a></li>"
  paginationText += "<li id=\"pagination-control-right\"><a href=\"#\">»</a></li>"
  paginationContainer.html(paginationText)
  addClickListeners()

addClickListeners = ->
  $(".pagination.pagination-sm a[href='#']").click (e) ->
    e.preventDefault()
    paginate($(this).text())

$ ->
  paginationContainer = $(".pagination.pagination-sm")
  audioCount = paginationContainer.data("audio-count")
  paginate(1)
