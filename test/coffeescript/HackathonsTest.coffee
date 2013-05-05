Browser = require 'zombie'
assert = require 'assert'

browser = new Browser { 
  site : 'http://localhost:4567/'
}

browser.visit '/', (err, browser) ->
  if err 
    console.log err.message
  else 
    console.log browser.html()
  browser.close()