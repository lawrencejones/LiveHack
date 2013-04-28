# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	p = window.location.pathname
	if p == '/hackathons' or p == '/'
		for row,i in $('#hackathon_list tr')
			if i != 0
				$(row).attr('hack_id',i)
				$(row).click ->
					id = $(this).attr('hack_id')
					window.location.pathname = "/hackathons/#{id}"
