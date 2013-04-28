# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	p = window.location.pathname
	if p == '/hackathons' or p == '/'
		process_home()
	if /\/hackathons\/+/.test(p)
		[first..., id] = p.split('/')
		process_hackathon(id)
		

process_home = () ->
	window.initialise_clock(1367161200000)
	console.log 'Initialised clock!'
	$('#new_hack').click ->

	for row,i in $('#hackathon_list tr')
		if i != 0
			$(row).attr('hack_id',i)
			$(row).click ->
				id = $(this).attr('hack_id')
				window.location.pathname = "/hackathons/#{id}"

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


#///////////////////////////////////////////////////////////////////
# Utilities
#///////////////////////////////////////////////////////////////////

populate_buddy_tables = ->
	for o,i in window.buddy_data
		row = $('<tr/>')
		row.append $("<td>#{o.name}</td>")
		colspan = 2
		if o.isIdea 
			row.append $("<td>#{o.idea}</td>")
			colspan = 3
		skills = $('<td/>')
		for skill in o.skills.split(',')
			skills.append $('<span/ class="badge badge-info>').html(skill)
		row.append skills
		fb = $("<tr class=\"fb_row\" id=\"buddy#{i}\"/>").append $("<td/ colspan=\"#{colspan}\">")
			.append('<div/ class="fb-comments">') 
			.attr('data-href',"http://livehack-facebook.herokuapp.com/buddy#{i}")
			.attr('data-num-posts','3')
			.appendTo row
			.css 'height', 0
		row.data('fb',fb).click ->
			alert()
			active_row = $('.fb_row').find('.active:eq(0)')
			$('.fb_row').find('.active').removeClass 'active'
			finished = (fb_row) ->
				fb_row.animate {
					height : '500px'
				}, {duration : 400}
			if active_row?
				active_row.animate {
					height : 0
				}, { duration : 300, complete : -> finished $(this).data('fb') }
		if o.isIdea then $('#ideas').append(row, fb) else row.appendTo($('#skills'))

