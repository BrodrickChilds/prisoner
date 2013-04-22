# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#game_user_tokens').tokenInput('/users.json', { crossDomain: false, onAdd: create_game });

create_game = (event) ->
  tokens = $('#game_user_tokens')
  token_values = tokens.tokenInput("get")
  tokens.tokenInput("clear")
  friend_id = token_values[0]['id']
  friend = $("<div></div>")
  friend_name = $("<h3>"+token_values[0]['name']+"</h3>")
  betray_link = $("<a href=#>Betray</a>")
  no_betray_link = $("<a href=#>Don't Betray</a>")
  friend.append(friend_name)
  friend.append(betray_link)
  friend.append("<span> </span>")
  friend.append(no_betray_link)
  friend.addClass("to_delete")
  betray_link.bind 'click', (event) =>
    betrayal_handler('y', friend_id)
  no_betray_link.bind 'click', (event) =>
    betrayal_handler('n', friend_id)
  $('.games').prepend(friend)
  
betrayal_handler = (intent, friend_id) ->
  link = $(this)
  betray = false
  level = $('.level').attr('id')
  if intent == 'y'
    betray = true
  $.ajax
    url: "/games"
    data: {game: {user_id: String(friend_id), opp_strat: betray, stage_id: level}}
    dataType: "script"
    type: "POST"
    complete: (data) ->
      game = link.parents(".to_delete")
      hide_game = -> game.fadeOut('slow')
      setTimeout hide_game, 5000
  return false
