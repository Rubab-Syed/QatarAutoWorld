$(document).ready(function () {
  
  // load SDK Asynchronously
  (function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.com/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  $('body').on("click", "#loginBtnfb", function() {
    //SDK loaded, initialize it                                                                                                              
    FB.init({
      appId      : '1299137070168094',
      cookie     : true,
      xfbml      : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();
 
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        FB.api('/me', {"fields":"id,name,email,first_name,last_name"}, function(response) {
          if (document.getElementById("name") !== null) {
            debugger;
            document.getElementById('name').value = response.name;
            document.getElementById('email').value = response.email;
          }
        });
      } else {
        FB.login(function(response) {
          FB.api('/me', {"fields":"id,name,email,first_name,last_name"}, function(response) {
            if (document.getElementById("name") != null) {
              debugger;
              document.getElementById('name').value = response.name;
              document.getElementById('email').value = response.email;
            }          
          });
        });
      }
    });
  });

  $('body').on("click", "#loginBtnG", function() {
    gapi.load('auth2', function() {	    
      GoogleAuth = gapi.auth2.init({
        client_id: "540756428962-ttf0rulvi4ii2hrv9cpbe9pbhark923l.apps.googleusercontent.com",
        scope: "profile email" // this isn't required
      });

  	  if (GoogleAuth.isSignedIn.get() === false) {
  	    GoogleAuth.signIn();
  	  }
      
      var user = GoogleAuth.currentUser.get();
      var profile = user.getBasicProfile();
  	  if (void 0 != profile && document.getElementById("name") !== null) {
        document.getElementById('name').value = profile.getName();
        document.getElementById('email').value = profile.getEmail();
      }
    });
  });
});
   
