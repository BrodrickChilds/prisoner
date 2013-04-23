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
  friend_parent = $("<div></div>")
  friend = $("<div></div>")
  friend_name = $("<h3>"+token_values[0]['name']+"</h3>")
  betray_link = $("<a href=# class='light-link'>Betray</a>")
  no_betray_link = $("<a href=# class='light-link'>Don't Betray</a>")
  friend.append(friend_name)
  friend.append(betray_link)
  friend.append("<span> </span>")
  friend.append(no_betray_link)
  friend_parent.append(friend)
  betray_link.bind 'click', (event) =>
    betrayal_handler(friend, 'y', friend_id)
  no_betray_link.bind 'click', (event) =>
    betrayal_handler(friend, 'n', friend_id)
  $('.games').prepend(friend_parent)
  
betrayal_handler = (friend, intent, friend_id) ->
  betray = false
  level = $('.level').attr('id')
  alert(level)
  if intent == 'y'
    betray = true
  $.ajax
    url: "/games"
    data: {game: {user_id: String(friend_id), opp_strat: betray, stage_id: level}}
    dataType: "script"
    type: "POST"
    complete: (data) ->
      friend.hide()
      success = $("<div> </div>")
      success.append("<h4> Request sent! </h4>")
      friend.parent().append(success)
      hide_game = -> 
        success.fadeOut('slow')
        if level == "1"
          location.reload()
      setTimeout hide_game, 5000
  return false
