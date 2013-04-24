# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#game_user_tokens').tokenInput('/users.json', { 
    crossDomain: false, 
    onAdd: friend_handler, 
    resultsFormatter: (item) ->
      return "<li>" + "<img src='" + item.url + "' title='" + item.name + "' height='25px' width='25px' />" + "<div style='display: inline-block; padding-left: 10px;'><div class='name'>" + item.name + "</div></div></li>"
  });
  $('a.random-request').click random_handler

random_handler = (event) ->
  event.preventDefault()
  $.ajax
    url: $(this).attr('href')
    data: null
    dataType: "json"
    type: "GET"
    complete: (data) ->
      info = JSON.parse(data.responseText)
      create_game(info.user.name, info.user.id, info.url)

  return false

friend_handler = (event) ->
  tokens = $('#game_user_tokens')
  token_values = tokens.tokenInput("get")
  tokens.tokenInput("clear")
  create_game(token_values[0]['name'], token_values[0]['id'])
  

create_game = (name, id, url) ->
  friend_parent = $("<div></div>")
  friend = $("<div></div>")
  friend_name = $("<h4> </h4>")
  if url == undefined
    friend_name.append(name)
  else
    friend_name.append("<img src=" + url + ">")
    friend_name.append(name)
  betray_link = $("<a href=# class='light-link'>Betray</a>")
  no_betray_link = $("<a href=# class='light-link'>Don't Betray</a>")
  friend.append(friend_name)
  friend.append(betray_link)
  friend.append("<span> </span>")
  friend.append(no_betray_link)
  friend_parent.append(friend)
  betray_link.bind 'click', (event) =>
    betrayal_handler(friend, 'y', id)
  no_betray_link.bind 'click', (event) =>
    betrayal_handler(friend, 'n', id)
  $('.pending-games').prepend(friend_parent)
  
betrayal_handler = (friend, intent, friend_id) ->
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
      friend.hide()
      success = $("<div> </div>")
      success.append(data.responseText)
      friend.parent().append(success)
      hide_game = -> 
        success.fadeOut('slow')
      setTimeout hide_game, 5000
  return false
