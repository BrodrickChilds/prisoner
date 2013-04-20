# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("a.game_respond").click game_response_handler

game_submit_handler = (event) ->
  return false
  $("form.create-game").submit game_submit_handler

game_response_handler = (event) ->
  event.preventDefault()
  game = $(this).parents(".game")
  console.log(game)
  $.ajax
    url: $(this).attr('href')
    data: null
    dataType: "script"
    type: "PUT"
    complete: (data) ->
      game_response = $("<div></div>")
      game_response.append(data.responseText)
      game.find(".game-internal").hide()
      game.append(game_response)

  return false
