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

#///////////////////////////////////////////////////////////////////
# New Hackathon Control Flow
#///////////////////////////////////////////////////////////////////
setup_new_modal_link = ->

	# Initiate the timepicker handle
	setup_time_picker = () ->
		$('.time-in').datetimepicker {format : 'yyyy-mm-dd hh:ii'}

	# Prevent users tabbing ahead of their current progress
	prevent_illegal_tabbing = () ->
		$('#form-tabs').click (e) ->
			console.log('click')
			if $(this).find('i[class="icon-check"]').length != 1
				return false
	
	# Clear all current fields
	clear_inputs = () ->
		$('.span5.no input').val('')
		$('#desc-in').val('')

	# Initialise button functionality
	sort_btns = () ->
		$('#go-back').click (e) ->
			e.preventDefault() if e?
			clear_inputs()
			$('#new-hack-modal').animate {opacity : 0}, \
				complete : -> 
					$('#new-hack-modal-content').remove()
					$('#hackathon-table').fadeIn()
					$('.subs').hide()
					$('#logged-in-subheading').show()
		$('#fbevent-select .btn')
			.click ->
				$(this).parent().find('.btn').removeClass('btn-primary')
				$(this).addClass('btn-primary')
				
				$('#event-table').css 'opacity', \
					if $(this).html() == "Yes" then 1 else 0.3
				if $(this).html() == "No" then clear_inputs()

	# Load the contents of event e into the fields
	load_event = (e) ->
		time_to_picker = (d) ->
			d = new Date(d)
			date = d.toISOString().split('T')[0]
			[hours,mins,ss...] = d.toISOString().split('T')[1].split(':')
			return date + ' ' + hours + ':' + mins
		event_data = $(this).data('event')
		$('#name').val event_data.name
		$('#start').val time_to_picker(event_data.start_time)
		$('#end').val time_to_picker(event_data.end_time)
		$('#location').val event_data.location
		$('#desc-in').val event_data.description
	
	# Populate the event table with facebook events
	populate_event_table = () ->
		FB.api all_attending_events, (r) ->
			for e in r
				console.log e
				top  = $('#event-row tr:eq(0)').clone()
				pic  = format_event_avatar(e.pic_square)

				name = $('<h5/ class="event-header">') \
					.addClass('push-up').html e.name
				start = format_date(new Date(e.start_time))
				sub  = $('<h5/>') \
					.addClass('event-header loc')
					.html (e.location + ' - ' + start)
				top.append pic, name, sub

				bottom = $('#event-row tr:eq(1)').clone()
				bottom.hide()
				bottom.find('.info').html(e.description.replace(/\n/g, "<br/>"))
				name.data('event',e).click load_event #expand_logic
				sub.data('event',e).click load_event #expand_logic
					
				$('#event-table').append top, bottom
				$('.no').css('min-height',$('.yes').height())

	# Initiate the first get for the new hack partial
	get_partial = (callback) ->
		$('#new-hack-modal').click (e) ->
			e.preventDefault()
			if $('#new-hack-container').length == 0
				$('#hackathon-table').fadeOut 200, ->
					$.ajax \
						type: "GET",
						url: "/hackathons/new",
						success: (data) ->
							$('.container').append(data)
							console.log 'Appended hack setup'
							callback()

	# Callback for completion of getting partial
	once_appended = ->
		sort_btns()
		populate_event_table()
		window.new_hack = null
		prevent_illegal_tabbing()
		setup_time_picker()
		$('.subs').hide()
		$('#creating-hack-subheading').show()

	# Go get it!
	get_partial(once_appended)


#///////////////////////////////////////////////////////////////////
# Home Page Control Flow
#///////////////////////////////////////////////////////////////////
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


#///////////////////////////////////////////////////////////////////
# A Hackathon View Control Flow
#///////////////////////////////////////////////////////////////////
process_hackathon = (id) ->
	$('body').data('id',id)
	update_hackathon_data ->
		update_schedule_data ->
			initialise_clock(window.hackathon.end)
			console.log "Initialising schedule"
			initialise_schedule()
			update_buddy_data(populate_buddy_tables)
	update_git_data()


#///////////////////////////////////////////////////////////////////
# Facebook 
#///////////////////////////////////////////////////////////////////

user_details =
	method : 'fql.query'
	query : 'SELECT name, email, username FROM user WHERE uid=me()'

all_attending_events = 
	method : 'fql.query'
	query : ('SELECT name, description, pic_square, venue, location, start_time, end_time ' + 
					'FROM event WHERE eid IN (' +
					'SELECT eid FROM event_member ' +
					'WHERE uid = me() and rsvp_status="attending")')

create_event = (e,callback) ->
	# Needs fields start_time, end_time, location, name, description
	# and privacy = "OPEN" || "CLOSED"
	FB.api '/me/events', 'post', e, (response) ->
		if response.id then console.log 'Event created'
		if callback? then callback()


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

format_event_avatar = (url) ->
   $("<img/ src=\"#{url}\">").addClass('event-img')

format_date = (d) ->
  pad = (a,b) ->
    (1e15+a+"").slice(-b)
  pad(d.getDate(),2) + '/' + pad(d.getMonth()+1,2) + '/' + d.getFullYear()

