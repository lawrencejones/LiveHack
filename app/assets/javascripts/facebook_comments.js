window.fbAsyncInit = function() {
// init the FB JS SDK
FB.init({
appId      : '510145552355935',                    // App ID from the app dashboard
status     : true,                                 // Check Facebook Login status
xfbml      : true                                  // Look for social plugins on the page
});

FB.getLoginStatus(function(response) {
  if (response.status === 'connected') {
// connected
} else if (response.status === 'not_authorized') {
// not_authorized
login();
} else {
// not_logged_in
login();
}
});

// Additional initialization code such as adding Event Listeners goes here
};

// Load the SDK asynchronously
(function(d, s, id){
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=510145552355935";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function login() {
  FB.login(function(response) {
    if (response.authResponse) {
// connected
testAPI();
} else {
// cancelled
}
});

  function testAPI() {
    console.log('Welcome!  Fetching your information.... ');
    FB.api('/me', function(response) {
      console.log('Good to see you, ' + response.name + '.');
    });
  }}  