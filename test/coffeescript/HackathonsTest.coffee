Browser = require 'zombie'
assert = require 'assert'
$ = require 'jQuery'
stdin = process.openStdin()

keys = {
  enter : 13
}

gen_keypress = (k) ->
  e = $.Event 'keydown'
  e.which = k
  return e

browser = new Browser()
browser.visit 'http://www.facebook.com', (err, browser, status) ->
  stdin.resume()
  email = 'lawrencelaptop@gmail.com'
  console.log "Enter facebook password for #{email}:"
  stdin.once 'data', (data) ->
    password = data.toString().trim()
    browser
      .fill('#email', email)
      .fill('#pass', password)
      .pressButton '#login_form input[type=submit]', (err) ->
        assert.equal status, '200', \
          "Issue with facebook login, err code #{status}"
        browser.visit 'http://localhost:4567/', (err, browser) ->
          if err 
            console.log err.message
          else
            # Ensure that initially, the save details button is
            # disabled
            #assert $('#save-details').hasClass('disabled'), \
            #  'Submit should be disabled'
            # Enter a skill into the skills box and verify creation
            # of a skill badge
            enter = gen_keypress keys['enter']
            # Enter java into the skills box
            browser.fill '#skills-in', 'java'
            # Trigger an enter keypress
            $('#skills-in').trigger enter
            # Ensure there is only a single skill badge on the page now
            console.log $('body').html()
            assert.equal $('.skill-badge').length, 1, \
              "Incorrect generation of skill-badge, #{$('.skill-badge').length}" +
              " badges when there should be 1"
            # Ensure skills box has been correctly cleared
            assert.equal $('#skills-in').val(), '', \
              "Skills wasn't cleared on enter"
            # Check once more that submission hasn't been enabled
            #assert $('#save-details').hasClass('disabled'), \
            #  'Submit should be disabled'
            console.log browser
            # Fill the github email with a value
            browser.fill '#github-in', 'lmj112@ic.ac.uk'
            # Verify that we can now press this
            assert !$('#save-details').hasClass('disabled'), \
              'Submit should be enabled'
            # Trigger the click on the submission button
            $('#save-details').trigger 'click'
            console.log 'Getting users.json'
            $.ajax type: 'GET', url: '/users.json', success: (data) ->
              console.log data
              for user in data
                if user.name == 'Lawrence Jones'
                  assert.equal user.tags, 'java', \
                    "Tags have not been correctly saved, java != #{user.tags}"