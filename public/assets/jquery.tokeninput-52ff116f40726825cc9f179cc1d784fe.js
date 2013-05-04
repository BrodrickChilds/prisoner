/*
 * jQuery Plugin: Tokenizing Autocomplete Text Entry
 * Version 1.6.0
 *
 * Copyright (c) 2009 James Smith (http://loopj.com)
 * Licensed jointly under the GPL and MIT licenses,
 * choose which one suits your project best!
 *
 */
(function(t){var e={method:"GET",contentType:"json",queryParam:"q",searchDelay:300,minChars:1,propertyToSearch:"name",jsonContainer:null,hintText:"Type in a search term",noResultsText:"No results",searchingText:"Searching...",deleteText:"&times;",animateDropdown:!0,tokenLimit:null,tokenDelimiter:",",preventDuplicates:!1,tokenValue:"id",prePopulate:null,processPrePopulate:!1,idPrefix:"token-input-",resultsFormatter:function(t){return"<li>"+t[this.propertyToSearch]+"</li>"},tokenFormatter:function(t){return"<li><p>"+t[this.propertyToSearch]+"</p></li>"},onResult:null,onAdd:null,onDelete:null,onReady:null},i={tokenList:"token-input-list",token:"token-input-token",tokenDelete:"token-input-delete-token",selectedToken:"token-input-selected-token",highlightedToken:"token-input-highlighted-token",dropdown:"token-input-dropdown",dropdownItem:"token-input-dropdown-item",dropdownItem2:"token-input-dropdown-item2",selectedDropdownItem:"token-input-selected-dropdown-item",inputToken:"token-input-input-token"},n={BEFORE:0,AFTER:1,END:2},s={BACKSPACE:8,TAB:9,ENTER:13,ESCAPE:27,SPACE:32,PAGE_UP:33,PAGE_DOWN:34,END:35,HOME:36,LEFT:37,UP:38,RIGHT:39,DOWN:40,NUMPAD_ENTER:108,COMMA:188},o={init:function(i,n){var s=t.extend({},e,n||{});return this.each(function(){t(this).data("tokenInputObject",new t.TokenList(this,i,s))})},clear:function(){return this.data("tokenInputObject").clear(),this},add:function(t){return this.data("tokenInputObject").add(t),this},remove:function(t){return this.data("tokenInputObject").remove(t),this},get:function(){return this.data("tokenInputObject").getTokens()}};t.fn.tokenInput=function(t){return o[t]?o[t].apply(this,Array.prototype.slice.call(arguments,1)):o.init.apply(this,arguments)},t.TokenList=function(e,o,r){function a(){return null!==r.tokenLimit&&M>=r.tokenLimit?(H.hide(),m(),void 0):void 0}function l(){if(N!==(N=H.val())){var t=N.replace(/&/g,"&amp;").replace(/\s/g," ").replace(/</g,"&lt;").replace(/>/g,"&gt;");R.html(t),H.width(R.width()+30)}}function c(e){var i=r.tokenFormatter(e);i=t(i).addClass(r.classes.token).insertBefore(O),t("<span>"+r.deleteText+"</span>").addClass(r.classes.tokenDelete).appendTo(i).click(function(){return f(t(this).parent()),$.change(),!1});var n={id:e.id};return n[r.propertyToSearch]=e[r.propertyToSearch],t.data(i.get(0),"tokeninput",e),P=P.slice(0,z).concat([n]).concat(P.slice(z)),z++,g(P,$),M+=1,null!==r.tokenLimit&&M>=r.tokenLimit&&(H.hide(),m()),i}function u(e){var i=r.onAdd;if(M>0&&r.preventDuplicates){var n=null;if(W.children().each(function(){var i=t(this),s=t.data(i.get(0),"tokeninput");return s&&s.id===e.id?(n=i,!1):void 0}),n)return h(n),O.insertAfter(n),H.focus(),void 0}(null==r.tokenLimit||r.tokenLimit>M)&&(c(e),a()),H.val(""),m(),t.isFunction(i)&&i.call($,e)}function h(t){t.addClass(r.classes.selectedToken),j=t.get(0),H.val(""),m()}function d(t,e){t.removeClass(r.classes.selectedToken),j=null,e===n.BEFORE?(O.insertBefore(t),z--):e===n.AFTER?(O.insertAfter(t),z++):(O.appendTo(W),z=M),H.focus()}function p(e){var i=j;j&&d(t(j),n.END),i===e.get(0)?d(e,n.END):h(e)}function f(e){var i=t.data(e.get(0),"tokeninput"),n=r.onDelete,s=e.prevAll().length;s>z&&s--,e.remove(),j=null,H.focus(),P=P.slice(0,s).concat(P.slice(s+1)),z>s&&z--,g(P,$),M-=1,null!==r.tokenLimit&&H.show().val("").focus(),t.isFunction(n)&&n.call($,i)}function g(e,i){var n=t.map(e,function(t){return t[r.tokenValue]});i.val(n.join(r.tokenDelimiter))}function m(){F.hide().empty(),L=null}function v(){F.css({position:"absolute",top:t(W).offset().top+t(W).outerHeight(),left:t(W).offset().left,zindex:999}).show()}function y(){r.searchingText&&(F.html("<p>"+r.searchingText+"</p>"),v())}function b(){r.hintText&&(F.html("<p>"+r.hintText+"</p>"),v())}function x(t,e){return t.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+e+")(?![^<>]*>)(?![^&;]+;)","gi"),"<b>$1</b>")}function w(t,e,i){return t.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+e+")(?![^<>]*>)(?![^&;]+;)","g"),x(e,i))}function _(e,i){if(i&&i.length){F.empty();var n=t("<ul>").appendTo(F).mouseover(function(e){k(t(e.target).closest("li"))}).mousedown(function(e){return u(t(e.target).closest("li").data("tokeninput")),$.change(),!1}).hide();t.each(i,function(i,s){var o=r.resultsFormatter(s);o=w(o,s[r.propertyToSearch],e),o=t(o).appendTo(n),i%2?o.addClass(r.classes.dropdownItem):o.addClass(r.classes.dropdownItem2),0===i&&k(o),t.data(o.get(0),"tokeninput",s)}),v(),r.animateDropdown?n.slideDown("fast"):n.show()}else r.noResultsText&&(F.html("<p>"+r.noResultsText+"</p>"),v())}function k(e){e&&(L&&C(t(L)),e.addClass(r.classes.selectedDropdownItem),L=e.get(0))}function C(t){t.removeClass(r.classes.selectedDropdownItem),L=null}function T(){var e=H.val().toLowerCase();e&&e.length&&(j&&d(t(j),n.AFTER),e.length>=r.minChars?(y(),clearTimeout(A),A=setTimeout(function(){S(e)},r.searchDelay)):m())}function S(e){var i=e+D(),n=I.get(i);if(n)_(e,n);else if(r.url){var s=D(),o={};if(o.data={},s.indexOf("?")>-1){var a=s.split("?");o.url=a[0];var l=a[1].split("&");t.each(l,function(t,e){var i=e.split("=");o.data[i[0]]=i[1]})}else o.url=s;o.data[r.queryParam]=e,o.type=r.method,o.dataType=r.contentType,r.crossDomain&&(o.dataType="jsonp"),o.success=function(n){t.isFunction(r.onResult)&&(n=r.onResult.call($,n)),I.add(i,r.jsonContainer?n[r.jsonContainer]:n),H.val().toLowerCase()===e&&_(e,r.jsonContainer?n[r.jsonContainer]:n)},t.ajax(o)}else if(r.local_data){var c=t.grep(r.local_data,function(t){return t[r.propertyToSearch].toLowerCase().indexOf(e.toLowerCase())>-1});t.isFunction(r.onResult)&&(c=r.onResult.call($,c)),I.add(i,c),_(e,c)}}function D(){var t=r.url;return"function"==typeof r.url&&(t=r.url.call()),t}if("string"===t.type(o)||"function"===t.type(o)){r.url=o;var E=D();void 0===r.crossDomain&&(r.crossDomain=-1===E.indexOf("://")?!1:location.href.split(/\/+/g)[1]!==E.split(/\/+/g)[1])}else"object"==typeof o&&(r.local_data=o);r.classes?r.classes=t.extend({},i,r.classes):r.theme?(r.classes={},t.each(i,function(t,e){r.classes[t]=e+"-"+r.theme})):r.classes=i;var A,N,P=[],M=0,I=new t.TokenList.Cache,H=t('<input type="text"  autocomplete="off">').css({outline:"none"}).attr("id",r.idPrefix+e.id).focus(function(){(null===r.tokenLimit||r.tokenLimit!==M)&&b()}).blur(function(){m(),t(this).val("")}).bind("keyup keydown blur update",l).keydown(function(e){var i,o;switch(e.keyCode){case s.LEFT:case s.RIGHT:case s.UP:case s.DOWN:if(t(this).val()){var r=null;return r=e.keyCode===s.DOWN||e.keyCode===s.RIGHT?t(L).next():t(L).prev(),r.length&&k(r),!1}i=O.prev(),o=O.next(),i.length&&i.get(0)===j||o.length&&o.get(0)===j?e.keyCode===s.LEFT||e.keyCode===s.UP?d(t(j),n.BEFORE):d(t(j),n.AFTER):e.keyCode!==s.LEFT&&e.keyCode!==s.UP||!i.length?e.keyCode!==s.RIGHT&&e.keyCode!==s.DOWN||!o.length||h(t(o.get(0))):h(t(i.get(0)));break;case s.BACKSPACE:if(i=O.prev(),!t(this).val().length)return j?(f(t(j)),$.change()):i.length&&h(t(i.get(0))),!1;1===t(this).val().length?m():setTimeout(function(){T()},5);break;case s.TAB:case s.ENTER:case s.NUMPAD_ENTER:case s.COMMA:if(L)return u(t(L).data("tokeninput")),$.change(),!1;break;case s.ESCAPE:return m(),!0;default:String.fromCharCode(e.which)&&setTimeout(function(){T()},5)}}),$=t(e).hide().val("").focus(function(){H.focus()}).blur(function(){H.blur()}),j=null,z=0,L=null,W=t("<ul />").addClass(r.classes.tokenList).click(function(e){var i=t(e.target).closest("li");i&&i.get(0)&&t.data(i.get(0),"tokeninput")?p(i):(j&&d(t(j),n.END),H.focus())}).mouseover(function(e){var i=t(e.target).closest("li");i&&j!==this&&i.addClass(r.classes.highlightedToken)}).mouseout(function(e){var i=t(e.target).closest("li");i&&j!==this&&i.removeClass(r.classes.highlightedToken)}).insertBefore($),O=t("<li />").addClass(r.classes.inputToken).appendTo(W).append(H),F=t("<div>").addClass(r.classes.dropdown).appendTo("body").hide(),R=t("<tester/>").insertAfter(H).css({position:"absolute",top:-9999,left:-9999,width:"auto",fontSize:H.css("fontSize"),fontFamily:H.css("fontFamily"),fontWeight:H.css("fontWeight"),letterSpacing:H.css("letterSpacing"),whiteSpace:"nowrap"});$.val("");var q=r.prePopulate||$.data("pre");r.processPrePopulate&&t.isFunction(r.onResult)&&(q=r.onResult.call($,q)),q&&q.length&&t.each(q,function(t,e){c(e),a()}),t.isFunction(r.onReady)&&r.onReady.call(),this.clear=function(){W.children("li").each(function(){0===t(this).children("input").length&&f(t(this))})},this.add=function(t){u(t)},this.remove=function(e){W.children("li").each(function(){if(0===t(this).children("input").length){var i=t(this).data("tokeninput"),n=!0;for(var s in e)if(e[s]!==i[s]){n=!1;break}n&&f(t(this))}})},this.getTokens=function(){return P}},t.TokenList.Cache=function(e){var i=t.extend({max_size:500},e),n={},s=0,o=function(){n={},s=0};this.add=function(t,e){s>i.max_size&&o(),n[t]||(s+=1),n[t]=e},this.get=function(t){return n[t]}}})(jQuery);