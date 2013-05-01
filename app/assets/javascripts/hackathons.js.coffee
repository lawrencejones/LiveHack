# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  setup_new_modal_link()
  get_font_awesome_classes()
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

  parse_fb_date = (d) ->
    [year,month,day] = d.split(' ')[0].split('-')
    [hour, minutes] = d.split(' ')[1].split(':')
    d = new Date(year, month-1, day, hour, minutes)
    return d.toISOString().split('.')[0]+'-0000'

  # Prevent users tabbing ahead of their current progress
  prevent_illegal_tabbing = () ->
    $('#form-tabs a').click (e) ->
      if !$(this).data('allowed')
        return false
  
  validate_inputs = () ->
    goahead = true
    $('.no input').each ->
      if $(this).val() == '' then goahead = false
    goahead and ($('.no textarea').val() != '')


  # Clear all current fields
  clear_inputs = () ->
    $('.span5.no input').val('')
    $('#desc-in').val('')
    $('#stage1submit').addClass('disabled')

  # Initialise button functionality
  sort_btns = () ->
    $('#form-tabs a').each ->
      $(this).data('allowed',false)

    $('#stage1submit').click ->
      if validate_inputs()
        window.new_hackathon = 
        {
          access_token : window.fbtoken
          name : $('#name').val()
          start_time : parse_fb_date($('#start').val())
          end_time : parse_fb_date($('#end').val())
          location : $('#location').val()
          privacy : 'OPEN'
        }
        if $('#fbevent-select .btn-primary').text() == 'No'
          FB.api '/me/events/', 'post', window.new_hackathon, (response) ->
            window.new_hackathon.eid = response.id
            console.log response.id
            segue_to_stage_2()
        else  # if selecting event
          window.new_hackathon.eid = window.selected_id
          segue_to_stage_2()

    $('#go-back').click (e) ->
      e.preventDefault() if e?
      clear_inputs()
      $('#new-hack-modal-content').animate {opacity : 0}, \
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
        clear_inputs()
        if $(this).html() == "No" 
          $('.stage1in').removeAttr('disabled')
          $('#stage1submit').text('Create Event')
        else
          $('.stage1in').attr('disabled','disabled')
          $('#stage1submit').text('Select Current Hackathon')
      .trigger 'click'

  segue_to_stage_2 = ->
    if !$('#form-tabs a:eq(1)').data('allowed')
      $('#form-tabs li:eq(0) a')
        .append $('<i/ class="icon-check">').css {
          'margin-top':'3px', 'color':'#0088cc'
        }
      $('#form-tabs a:eq(1)').data('allowed',true)
      $('#form-tabs a:eq(1)').trigger 'click'
      setup_stage2()

  setup_stage2 = ->
    $('#friend-selector-container').bind 'jfmfs.selection.changed', (e, data) ->
      if data.length == 0  # no selected friends
        $('#stage2send').text('Skip Invites')
      else $('#stage2send').text('Send Requests')
    $('#friend-selector-container').bind 'jfmfs.friendload.finished', ->
      $('#stage2send').click ->
        selectedFriends = $('#friend-selector-container')
          .data('jfmfs').getSelectedIds()
        if selectedFriends.length > 0
          FB.api "/#{window.new_hackathon.eid}/invited?users=" + 
            selectedFriends.toString(), 'post', (r) ->
              if r.error? # when one user fails
                console.log 'Problem with array, adding one by one...'
                for f in selectedFriends
                  FB.api "/#{window.new_hackathon.eid}/invited/#{f}", \
                    'post', (r) ->
                      if r.error? then console.log f + ' failed'
                      else console.log f + ' was added'
              else console.log 'Friends are invited'
              segue_to_stage_3()
        else segue_to_stage_3(0)

    FB.api '/me/friends', (r) -> 
      c = $('#friend-selector-container').jfmfs()
      c.jfmfs {
        labels :
          filter_default: "Type a friends name"
          filter_title : "Find hackers!"
          all: "All"
      }

  validate_font_selection = (val) ->
    klass = (c for c in window.font_awesome_classes when \
     c == val)[0]
    if klass? 
      $('#live-preview-icon').attr 'class', klass
      if valid_fields(true) then $('#schedule-item-add').removeClass 'disabled'


  valid_fields = (ignore) ->
    valid = true
    $('.schedule-item-form input').each ->
      if $(this).val() == '' then valid = false
    klass = $('#font-input').val()
    if ignore? then return valid
    valid and (f for f in window.font_awesome_classes when f == klass).length > 0

  setup_stage3 = () ->
    $('.schedule-item-form input').bind 'input', ->
      if valid_fields()
        $('#schedule-item-add').removeClass 'disabled'
      else $('#schedule-item-add').addClass 'disabled'

    window.new_hackathon.schedule_items = []
    $('#font-input').typeahead {
      source: window.font_awesome_classes
      items : 4, updater: (i) -> 
        validate_font_selection i
        return i
    }

    $('#font-input').bind 'input', ->
      validate_font_selection $(this).val()

    $('#schedule-item-add').click ->
      window.new_hackathon.schedule_items.push
        label : $('#schedule-label-in').val()
        start : new Date $('#schedule-start-in').val()
        font : $('#font-input').val()
      $('.schedule-item-form input').val('')
      update_schedule_item_table(window.new_hackathon.schedule_items)

  segue_to_stage_3 = (timeout) ->
    timeout ?= 2000
    $('#invite-header').text('Friends have been invited!')
    after_pause = () ->
      $('#form-tabs a:eq(1)')
        .data('allowed',false)
        .append $('<i class="icon-check">')
      $('#form-tabs a:eq(2)')
        .data('allowed',true).trigger 'click'
      setup_stage3()
    setTimeout(after_pause,timeout)

  update_schedule_item_table = (items) ->
    $('#sch-item-table .item').remove()
    console.log items
    for item in items
      $('#sch-item-row-template .sch-label').html item.label
      console.log format_date(item.start)
      $('#sch-item-row-template .time').html \
        '<b>' + item.start.toLocaleTimeString().split(':')[0..1]
          .reduce((a,b) -> a + ':' + b) + '</b>  ' + 
        format_date(item.start)
      $('#sch-item-row-template .font').html item.font
      $('#sch-item-row-template .font').append \
        $("<i/ class=\"#{item.font}\">").css 'margin-left', '15px'
      $('#sch-item-row-template').clone().attr('id','')
        .appendTo $('#sch-item-table')


  start_live_validation = () ->
    live_check = ->
      if validate_inputs() then $('#stage1submit').removeClass 'disabled'
      else $('#stage1submit').addClass 'disabled'
    $('.no input').bind 'input', live_check
    $('.no textarea').bind 'input', live_check

  # Load the contents of event e into the fields
  load_event = (e) ->
    time_to_picker = (d) ->
      d = new Date(d)
      date = d.toISOString().split('T')[0]
      [hours,mins,ss...] = d.toISOString().split('T')[1].split(':')
      return date + ' ' + hours + ':' + mins
    if $('#fbevent-select button:eq(0)').hasClass('btn-primary')
      event_data = $(this).data('event')
      $('#name').val event_data.name
      $('#start').val time_to_picker(event_data.start_time)
      $('#end').val time_to_picker(event_data.end_time)
      $('#location').val event_data.location
      $('#desc-in').val event_data.description
      $('#stage1submit').removeClass('disabled')
      window.selected_id = event_data.eid

  # Populate the event table with facebook events
  populate_event_table = () ->
    FB.api all_attending_events, (r) ->
      for e in r
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
    start_live_validation()
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
      window.fbtoken = response.authResponse.accessToken
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
      window.fbtoken = response.authResponse.accessToken
      console.log "Connected to facebook"
      FB.api('/me', (r) -> console.log 'Welcome ' + r.name)
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
  query : ('SELECT eid, name, description, pic_square, venue, location, start_time, end_time ' + 
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

get_font_awesome_classes = ->
  $.ajax \
    type: 'GET',
    dataType: 'text',
    url: '/text/font-awesome-classes.txt',
    success: (data) ->
      window.font_awesome_classes = data.split(',')

format_date = (d) ->
  pad = (a,b) ->
    (1e15+a+"").slice(-b)
  pad(d.getDate(),2) + '/' + pad(d.getMonth()+1,2) + '/' + d.getFullYear()

