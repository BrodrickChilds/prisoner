(function(){var t,e,i,n;$(function(){return $("#game_user_tokens").tokenInput("/users.json",{crossDomain:!1,onAdd:i,hintText:"Type in a friend's name",tokenFormatter:function(t){return"<li><img src='"+t.url+"' title='"+t.name+"' height='25px' width='25px' />"+"<div style='display: inline-block; padding-left: 10px;'><div class='name'>"+t.name+"</div></div></li>"},resultsFormatter:function(t){return"<li><img src='"+t.url+"' title='"+t.name+"' height='25px' width='25px' />"+"<div style='display: inline-block; padding-left: 10px;'><div class='name'>"+t.name+"</div></div></li>"}}),$("a.random-request").click(n)}),n=function(t){return t.preventDefault(),$.ajax({url:$(this).attr("href"),data:null,dataType:"json",type:"GET",complete:function(t){var i;return i=JSON.parse(t.responseText),e(i.user.name,i.user.id,i.url,i.show_info,i.last_five,i.time_left)}}),!1},i=function(){var t,i;return i=$("#game_user_tokens"),t=i.tokenInput("get"),i.tokenInput("clear"),$.ajax({url:"/users/"+t[0].id,data:null,dataType:"json",type:"get",complete:function(t){var i;return i=JSON.parse(t.responseText),e(i.user.name,i.user.id,i.url,i.show_info,i.last_five,i.time_left)}})},e=function(e,i,n,s,o,a){var r,l,c,h,u,d,p;return h=$("<div></div>"),l=$("<div></div>"),c=$("<div class='name'> </div>"),void 0===n?c.append(" "+e):(c.append("<img src="+n+">"),c.append(" "+e)),d=$("<div class='actions'></div>"),r=$("<a href=# class='light-link'>Betray</a>"),p=$("<a href=# class='light-link'>Don't Betray</a>"),d.append(r),d.append("<span> </span>"),d.append(p),u=$("<div class='recent-game-info'> </div>"),u.append("Time left in prison: "+a+" weeks </br> Betrayed opponents in "+o+"% of their last five games on this level"),l.append(c),s&&l.append(u),l.append(d),h.append(l),r.bind("click",function(){return t(l,"y",i)}),p.bind("click",function(){return t(l,"n",i)}),$(".pending-games").prepend(h)},t=function(t,e,i){var n,s;return n=!1,s=$(".level").attr("id"),"y"===e&&(n=!0),$.ajax({url:"/games",data:{game:{user_id:String(i),opp_strat:n,stage_id:s}},dataType:"script",type:"POST",complete:function(e){var i,n;return t.hide(),n=$("<div> </div>"),n.append(e.responseText),t.parent().append(n),i=function(){return n.fadeOut("slow")},setTimeout(i,5e3)}}),!1}}).call(this);