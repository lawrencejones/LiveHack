# App ID
# Channel File
# check login status
# enable cookies to allow the server to access the session
# parse XFBML

# Load the SDK Asynchronously
window.fbAsyncInit = (callback) ->
  if callback?
    FB.init
      appId: "490022274396930"
      channelUrl: "/channel.html"
      status: true
      cookie: true
      xfbml: true
    callback()