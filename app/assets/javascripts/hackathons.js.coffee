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
	console.log 'Initialised!'
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

#///////////////////////////////////////////////////////////////////
# Utilities
#///////////////////////////////////////////////////////////////////

produce_schedule = ->
	make_schedule = () ->
		for item in window.scheduleItems
			make_circle(30,'#F0F0F0',true).appendTo('#my_sch')

make_circle = (r, c, shadow) ->
  shadow ?= true   # Default to true
  s = '0 0 1px black'
  circle = $('<div/ class="circle">').css
      background : c, height : r, width : r
      'border-radius' : r
      '-moz-border-radius' : r, '-webkit-border-radius' : r
      marginTop : -r/2, marginLeft : -r/2
  if shadow then circle.css
      '-webkit-box-shadow': s, '-moz-box-shadow': s, 'box-shadow' : s
  return circle