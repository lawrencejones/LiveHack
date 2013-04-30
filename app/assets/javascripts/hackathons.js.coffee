# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	setup_new_modal_link()
	window.fbAsyncInit routes

routes = ->
	p = window.location.pathname
	if p == '/hackathons' or p == '/'
		process_home()
	else if /\/hackathons\/+/.test(p)
		[first..., id] = p.split('/')
		process_hackathon(id)
	else if p == '/user/new'
		process_new_user()

setup_new_modal_link = ->
	sort_btns = () ->
		$('#fbevent-select .btn')
			.click ->
				$(this).parent().find('.btn').removeClass('btn-primary')
				$(this).addClass('btn-primary')
	
	populate_event_table = () ->
		FB.api(all_attending_events, (r) -> console.log r)

	$('#new-hack-modal').click (e) ->
		e.preventDefault()
		if $('#new-hack-container').length == 0
			$('#hackathon-table').fadeOut 200, ->
				$.ajax \
					type: "GET",
					url: "/hackathons/new",
					success: (data) ->
						$('.container').append(data)
						sort_btns()
						populate_event_table()
						window.new_hack = null
						console.log 'Appended hack setup'

process_home = ->

	check_login_result = (response) -> 
		if response.authResponse
			console.log 'Login succeeded'
			FB.api('/me', (r) -> console.log 'Welcome ' + r.name)
			logged_in()
		else alert 'Login failed'

	initiate_login = ->
		$('#login-btn').click ->
			FB.login \
				check_login_result,
				{scope : 'user_events,email,read_friendlists,create_event,rsvp_event'}


	FB.getLoginStatus (response) ->
    if response.status is "connected"
      console.log "Connected to facebook"
      logged_in()
    else  # if we're not in, provide button
      $('#login-btn').css 'visibility', 'visible'
      if response.status is "not_authorized"
        console.log "Not fb authed"
      else console.log "Not fb logged in"
	
  # Initialise new hackathon button with rails remote
	$.rails.handleRemote $('#sub-new-hack')
	# Initialise hackathon row functionality
	$('#hackathon_list tr').click ->
		segue_to_hackathon $(this).attr('id')
	# Deal with the login
	initiate_login()

process_hackathon = (id) ->
	$('body').data('id',id)
	update_hackathon_data ->
		update_schedule_data ->
			initialise_clock(window.hackathon.end)
			console.log "Initialising schedule"
			initialise_schedule()
			update_buddy_data(populate_buddy_tables)
	update_git_data()

process_new_user = ->
	$('button[type="submit"]').click ->
		alerted = false
		data = {}
		for field in $('.field').find('input')
			if $(field).val() == ''
				alert("Fields are left blank") if not alerted
				alerted = true
			else
				data[$(field).attr('id').split('_')[1]]
		console.log data

#///////////////////////////////////////////////////////////////////
# Data getters
#///////////////////////////////////////////////////////////////////

window.update_hackathon_data = (callback) ->
	id = $('body').data('id')
	$.ajax
		type: 'GET'
		url: window.location.href + '.json'
		dataType: 'json'
		success: (data) ->
			window.hackathon = data
			console.log 'Updated hackathon items.'
			if callback? then callback()


window.update_git_data = (callback) ->
	$.ajax
		type: 'GET'
		url: window.location.origin + '/git_data.json'
		dataType: 'json'
		success: (data) ->
			window.git_data = data
			console.log 'Updated git data.'
			if callback? then callback()


window.update_schedule_data = (callback) ->
	id = $('body').data('id')
	$.ajax
		type: 'GET'
		url: window.location.origin + '/schedule_items.json'
		dataType: 'json'
		success: (scheduleItems) ->
			specificItems = window.hackathon.scheduleItems.split(',')
			window.scheduleItems = []
			for item in scheduleItems
				for j in specificItems
					if j == item.id.toString() then window.scheduleItems.push item
			console.log "Updated schedule items."
			console.log window.scheduleItems
			if callback? then callback()

window.update_buddy_data = (callback) ->
	$.ajax
		type: 'GET'
		url: window.location.origin + '/buddy_data.json'
		dataType: 'json'
		success: (data) ->
			window.buddy_data = data
			console.log "Updated buddy data."
			if callback? then callback()


window.update_git = (callback) ->
	window.git_commits = []
	for gd in window.git_data
		lastCommitTime = gd.time if gd.time > lastCommitTime
		$.getJSON "https://api.github.com/repos/" + gd.user + "/" + gd.repo + "/" + "commits", (commits) ->
			for c in commits
				time = Date.parse(c.commit.author.date)
				window.git_commits.push 
					name: c.commit.author.name
					comment: c.commit.message
					time: time
	window.git_commits.sort (a,b) ->
		b.time - a.time



#///////////////////////////////////////////////////////////////////
# Utilities
#///////////////////////////////////////////////////////////////////

logged_in = ->
	# Hide the login button, no longer needed
	$('#login-btn').hide()
	$('#initial-subheading').hide()
	$('#logged-in-subheading').show()
	# Add the user if they are not already in the system
	FB.api user_details, (array) -> 
		add_user array[0], generate_hackathon_table

generate_hackathon_table = ->
	console.log 'Generating hackathon table'
	# Current username
	username = window.user.username
	$.ajax \
		type: "POST",
		url: "hackathons/subscribed_to",
		data: {username : username},
		success: (data) ->
			$('#hackathon-table').hide().append(data).fadeIn()
			console.log 'Appended table'

#///////////////////////////////////////////////////////////////////
# Facebook Queries
#///////////////////////////////////////////////////////////////////

user_details =
	method : 'fql.query'
	query : 'SELECT name, email, username FROM user WHERE uid=me()'

all_attending_events = 
	method : 'fql.query'
	query : ('SELECT name, venue, location, start_time ' + 
					'FROM event WHERE eid IN (' +
					'SELECT eid FROM event_member ' +
					'WHERE uid = me() and rsvp_status="attending")')


#///////////////////////////////////////////////////////////////////
# Rails Posting
#///////////////////////////////////////////////////////////////////

add_user = (user,callback) ->
	$.ajax \
		type: "POST",
		url: '/users.json',
		data: { user : user },
		success: ->
			window.user = user
			console.log 'Posted user'
			if callback? then callback()

