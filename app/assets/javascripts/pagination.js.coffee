# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Unobtrusive JavaScript: http://guides.rubyonrails.org/working_with_javascript_in_rails.html

audioCount = 1
currentTrack = 1
leftmostTrack = 1
maxPagination = 10

# Hack solution: http://stackoverflow.com/a/12319131
paginationContainer ="bouboule"

window.paginate = (n) ->
  switch n
    when '<<'
      if leftmostTrack > 1
        leftmostTrack--
    when '>>'
      if leftmostTrack < audioCount - maxPagination + 1
        leftmostTrack++
    else
      # Convert to Number
      currentTrack = +n
      # Bound right
      leftmostTrack = currentTrack - maxPagination + 1 if currentTrack > leftmostTrack + maxPagination - 1
      # Bound left
      leftmostTrack = currentTrack if currentTrack < leftmostTrack

  # Append pagination html
  paginationText = ""

  # Left button
  paginationText += "<li><a href=\"#\"><<</a></li>" unless leftmostTrack is 1

  # Page buttons
  for index in [leftmostTrack..(leftmostTrack + maxPagination - 1)]
    break if index > audioCount
    pageAttr = if index is currentTrack then " class=\"active\"" else ""
    paginationText += "<li#{pageAttr}><a href=\"#\">#{index}</a></li>"

  # Right button
  paginationText += "<li><a href=\"#\">>></a></li>" unless leftmostTrack + maxPagination > audioCount
  
  paginationContainer.html(paginationText)

  # Add click listeners
  $(".pagination.pagination-sm a[href='#']").click (e) ->
    e.preventDefault()
    trackId = $(this).text()
    playTrack(trackId)
    paginate(trackId)

$ ->
  paginationContainer = $(".pagination.pagination-sm")
  audioCount = paginationContainer.data("audio-count")
  paginate(1)
