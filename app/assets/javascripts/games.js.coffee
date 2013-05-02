# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#game_user_tokens').tokenInput('/users.json', { 
    crossDomain: false, 
    onAdd: friend_handler, 
    hintText: "Type in a friend's name",
    tokenFormatter: (item) ->
      return "<li>" + "<img src='" + item.url + "' title='" + item.name + "' height='25px' width='25px' />" + "<div style='display: inline-block; padding-left: 10px;'><div class='name'>" + item.name + "</div></div></li>"
    ,
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
      create_game(info.user.name, info.user.id, info.url, info.show_info, info.last_five, info.time_left)

  return false

friend_handler = (event) ->
  tokens = $('#game_user_tokens')
  token_values = tokens.tokenInput("get")
  tokens.tokenInput("clear")
  $.ajax
    url: "/users/"+token_values[0]['id']
    data: null
    dataType: "json"
    type: "get"
    complete: (data) ->
      info = JSON.parse(data.responseText)
      create_game(info.user.name, info.user.id, info.url, info.show_info, info.last_five, info.time_left)

create_game = (name, id, url, show_info, last_five, time_left) ->
  friend_parent = $("<div class='game'></div>")
  friend = $("<div class='game-internal game-unit'></div>")
  friend_name = $("<div class='name'> </div>")
  if url == undefined
    friend_name.append(" " + name)
  else
    friend_name.append("<img src=" + url + ">")
    friend_name.append(" " + name)
  links = $("<div class='respond'></div>")
  betray_link = $("<a href=# class='game_respond light-link btn btn-success cbutton>Betray</a>")
  no_betray_link = $("<a href=# class='game_respond light-link btn btn-danger cbutton'>Cooperate</a>")
  links.append(no_betray_link)
  links.append("<span> </span>")
  links.append(betray_link)
  information = $("<div class='recent-game-info'> </div>")
  information.append("Time left in prison: " + time_left + " weeks </br> Betrayed opponents in " + last_five + "% of their last five games on this level")
  friend.append(friend_name)
  if show_info
    friend.append(information)
  friend.append(links)
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
