(function(){jQuery(function(){return $("body").prepend('<div id="fb-root"></div>'),$.ajax({url:""+window.location.protocol+"//connect.facebook.net/en_US/all.js",dataType:"script",cache:!0})}),window.fbAsyncInit=function(){return FB.init({appId:"212052785607548",cookie:!0}),$("#sign_in").click(function(t){return console.log("here.."),t.preventDefault(),FB.login(function(t){return t.authResponse?(console.log("got a response!..."),window.location="/auth/facebook"):window.location="/"})})}}).call(this);