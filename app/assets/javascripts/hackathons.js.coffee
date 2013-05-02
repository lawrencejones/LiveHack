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

# start the automatic javascript requests to keep
# the server data up to date
start_refresh_intervals = ->


#///////////////////////////////////////////////////////////////////
# New Hackathon Control Flow
#///////////////////////////////////////////////////////////////////

dismantle_new_hack_and_return = (callback) ->
  $('#new-hack-modal-content').animate {opacity : 0, duration : 300}, \
    complete : -> 
      $('#new-hack-modal-content').remove()
      $('.modal-backdrop').remove()
      $('.datetimepicker').remove()
      $('.subs').hide()
      $('#logged-in-subheading').show()
      update_hackathons_if_needed generate_hackathon_table
      if callback? then callback()

show_new_hackathon_summary = (event_details) ->
  goback = $('<a href="#">Go Back</a>').click (e) ->
    e.preventDefault()
    dismantle_new_hack_and_return()
  $('#form-tabs a:eq(2)').append $('<i/ class="icon-check">')
  $('#stage3-header').html('All done! ').append goback
  $('#stage3-caption').html("#{event_details.name} been created, happy hacking!")
  $('.stage3-only').animate {opacity : 0}, {
    duration : 300, complete: ->
      $('.stage3-only').slideUp()
  }


# bind the new hack link to the creation of the form
setup_new_modal_link = ->

  # Prevent users tabbing ahead of their current progress
  prevent_illegal_tabbing = () ->
    $('#form-tabs a').click (e) ->
      if !$(this).data('allowed')
        return false
  
  #/////////// STAGE 1 ////////////////////////////////////////////
  
  # Verify all inputs are present
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

  # start the listening for changes
  start_live_validation = () ->
    live_check = ->
      if validate_inputs() then $('#stage1submit').removeClass 'disabled'
      else $('#stage1submit').addClass 'disabled'
    $('.no .stage1in').bind 'input', live_check

  # display the event modal
  create_event_warning_modal = (event_data) ->
    modal = $('#event-warning-modal-template .modal')
    modal.find('.fb-hackathon-link')
      .html(event_data.name)
      .attr('href', "http://www.facebook.com/#{event_data.eid}")
      .click (e) ->
        e.preventDefault()
        window.open $(this).attr 'href'
    modal.find('.quit-modal').click (e) ->
      e.preventDefault()
      modal.modal('hide')
    modal.find('.go-home').click (e) ->
      e.preventDefault()
      modal.modal('hide')
      dismantle_new_hack_and_return()
    modal.modal('show')


  # Load the contents of event_data into the fields
  load_event = () ->
    event_data = $(this).data('event')
    $.ajax \
      type: 'POST',
      url: '/hackathons/exists.json',
      data: {eid : event_data.eid},
      dataType: 'json',
      success: (data) ->
        console.log data.status
        if data.status == 'stop'
          create_event_warning_modal(event_data)
        else if $('#fbevent-select button:eq(0)').hasClass('btn-primary')
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
        start = format_fb_date(e.start_time)
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

  # Initialise button functionality
  sort_btns = () ->
    # set allowed tabbing properties to no for all
    $('#form-tabs a').each ->
      $(this).data('allowed',false)

    # for the submit button click
    $('#stage1submit').click ->
      if validate_inputs()
        window.new_hackathon = 
        {
          access_token : window.fbtoken
          name : $('#name').val()
          start_time : format_fb_date($('#start').val())
          end_time : format_fb_date($('#end').val())
          location : $('#location').val()
          description : $('#desc-in').val()
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

  #/////////// STAGE 2 ////////////////////////////////////////////

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

  #/////////// STAGE 3 ////////////////////////////////////////////

  # Validate that the current value is a font-awesome class
  validate_font_selection = (val) ->
    klass = (c for c in window.font_awesome_classes when \
     c == val)[0]
    if klass? 
      $('#live-preview-icon').attr 'class', klass
      if valid_fields(true) then $('#schedule-item-add').removeClass 'disabled'

  # check if all fields are valid (including the font-awesome, 
  # excepting when ignore is true)
  valid_fields = (ignore) ->
    valid = true
    $('.schedule-item-form input').each ->
      if $(this).val() == '' then valid = false
    klass = $('#font-input').val()
    if ignore? then return valid
    valid and (f for f in window.font_awesome_classes when f == klass).length > 0

  # move to stage 3
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

  # setup the initial button functions etc
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
      if !$(this).hasClass 'disabled'
        window.new_hackathon.schedule_items.push
          label : $('#schedule-label-in').val()
          start : picker_to_jsdate $('#schedule-start-in').val()
          font : $('#font-input').val()
        $('.schedule-item-form input').val('')
        update_schedule_item_table(window.new_hackathon.schedule_items)

    $('#finish-new-hack').click -> 
      if !$(this).hasClass 'disabled'
        $(this).addClass 'disabled'
        add_hackathon window.new_hackathon, show_new_hackathon_summary

  # refresh table with contents of items
  update_schedule_item_table = (items) ->
    $('#sch-item-table .item').remove()
    console.log items
    for item in items
      $('#sch-item-row-template .sch-label').html item.label
      $('#sch-item-row-template .time').html \
        '<b>' + item.start.toLocaleTimeString().split(':')[0..1]
          .reduce((a,b) -> a + ':' + b) + '</b>  ' + 
        format_date(item.start)
      $('#sch-item-row-template .font').html item.font
      $('#sch-item-row-template .font').append \
        $("<i/ class=\"#{item.font}\">").css 'margin-left', '15px'
      $('#sch-item-row-template').clone().attr('id','')
        .appendTo $('#sch-item-table')

  #/////////// GENERAL NEW HACKATHON STUFF ///////////////////////

  # Initiate the first get for the new hack partial
  get_partial = (callback) ->
    $('#new-hack-modal').click (e) ->
      e.preventDefault()
      if $('#new-hack-container')?
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
    # for the go back click, dismantle everything
    $('#go-back').click (e) ->
      e.preventDefault() if e?
      $('#new-hack-modal-content').animate {opacity : 0}, \
        complete : -> 
          $('#new-hack-modal-content').remove()
          $('#hackathon-table').fadeIn()
          $('.subs').hide()
          $('#logged-in-subheading').show()

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
  
  # Initialise hackathon row functionality
  $('#hackathon_list tr').click ->
    segue_to_hackathon $(this).attr('id')
  $('#git-label')
    .tooltip {
      placement:'right'
      title : 'We use your github email to pull your commits for ' +
        'display on the hackathon page- just a bit of fun!'
    }
  $('#skills-label')
    .tooltip {
      placement : 'left'
      title : "Skills such as 'java', 'coffeescript', 'ios'"
    }
  # Deal with the login
  initiate_login()


#///////////////////////////////////////////////////////////////////
# A Hackathon View Control Flow
#///////////////////////////////////////////////////////////////////

load_hackathon_view = (id) ->
  $.get "/hackathons/#{id}.json", (hack) ->
    window.hackathon = hack
    $.ajax \
      type: 'GET',
      url: "/hackathons/#{id}",
      dataType: 'html',
      success: (data) ->
        $('body').html('').append(data)
        end = formatted_date_to_jsdate window.hackathon.end
        window.initialise_clock end


#///////////////////////////////////////////////////////////////////
# Facebook 
#///////////////////////////////////////////////////////////////////

user_details =
  method : 'fql.query'
  query : 'SELECT name, email, username, uid FROM user WHERE uid=me()'

all_attending_events = 
  method : 'fql.query'
  query : ('SELECT eid, name, description, pic_square, venue, location, start_time, end_time ' + 
          'FROM event WHERE eid IN (' +
          'SELECT eid FROM event_member ' +
          'WHERE uid = me() and rsvp_status="attending")')

users_for_event_query = (eid) ->
  'SELECT uid, name FROM user WHERE uid IN (' +
  "  SELECT uid FROM event_member WHERE eid = \"#{eid}\")"

#///////////////////////////////////////////////////////////////////
# Rails Access
#///////////////////////////////////////////////////////////////////

# only use for adding OUR user
add_user = (user,callback) ->
  $.ajax \
    type: "POST",
    url: '/users.json',
    dataType: 'json',
    data: { user : user },
    success: (data) ->
      console.log 'Posted user'
      window.user = data
      if callback? then callback(data)

add_hackathon = (hack,callback) ->
  console.log hack
  FB.api "/#{hack.eid}/invited", (r) ->
    hack.users = r.data
    $.ajax \
      type: 'POST',
      url: '/hackathons.json',
      data: {hackathon : hack},
      dataType: 'json',
      success: (data) ->
        console.log 'Posted hackathon'
        console.log data
        if data.status != 'failed'
          if callback? then callback(data)


#///////////////////////////////////////////////////////////////////
# Utilities
#///////////////////////////////////////////////////////////////////

# YYYY-MM-DD  ||   YYYY-MM-DD'T'hh:mm:ss... -> YYYY-MM-DD hh:mm
time_to_picker = (d) ->
  if d is null then return null
  date = d
  date = d.split('T')[0] if !(d.length == 10)
  time = d.split('T')[1] ? '00:00'
  [hours,mins,ss...] = time.split(':')
  return date + ' ' + hours + ':' + mins

# YYYY-MM-DD hh:mm  ->  JSDATE
picker_to_jsdate = (d) ->
  [y,m,d,h,m] = 
    (d.split(' ')[0].split('-').concat d.split(' ')[1].split(':'))
      .map (x) -> parseInt x, 10
  new Date(y, m-1, d, h, m)

# YYYY/MM/DD hh:mm  ->  JSDATE
formatted_date_to_jsdate = (d) ->
  console.log 'format?'
  console.log d
  [y,m,d,h,m] =
    (d.split(' ')[0].split('/').concat d.split(' ')[1].split(':'))
      .map (x) -> parseInt x, 10
  new Date(y, m-1, d, h, m)

# YYYY-MM-DD'T'*  ->  YYYY/MM/DD
format_fb_date = (d) ->
  if d.length == 10
    return d.replace(/-/g,'/')
  d.split('T')[0].split('-').reduce (a,b) -> a + '/' + b

logged_in = ->
  # Hide the login button, no longer needed
  $('#login-btn').hide()
  $('#initial-subheading').hide()
  $('#logged-in-subheading').show()
  # Add the user if they are not already in the system
  FB.api user_details, (array) ->
    user = array[0]
    user = {
      username : user.uid
      email : user.email
      name : user.name
    }
    add_user user, ask_for_sign_up

ask_for_sign_up = (user) ->
  console.log user
  if user.signed_up?
    update_hackathons_if_needed generate_hackathon_table
  else
    $('.user-details-in.name').val user.name
    $('.user-details-in.email, #github-in').val user.email
    $('#user-details-form').fadeIn()
    $('#skills-in').keypress (key) ->
      skill = $('#skills-in').val()
      if key.which == 13 and skill != ''
        key.preventDefault()
        badge = $('#skill-badge-template span').clone().html skill.toLowerCase()
        badge.appendTo $('#skills')
        badge.click -> $(this).remove()
        $('#skills-in').val('')
    $('#github-in').bind 'input', ->
      if $(this).val().length == 0
        $('#save-details').addClass 'disabled' 
      else $('#save-details').removeClass 'disabled'
    $('#save-details').click ->
      if !$(this).hasClass 'disabled'
        window.user.github_email = $('#github-in').val()
        skills = []
        $('#skills span').each -> skills.push $(this).html()
        window.user.tags = skills.toString()
        window.user.signed_up = true
        $.ajax \
          type: 'POST',
          url: '/users.json',
          data: {user : window.user, giving_details : true},
          dataType : 'json',
          success: (data) ->
            if data.github_email == window.user.github_email
              # it all worked
              $('#save-details').html('Success!')
              $('#user-details-form').delay(300).fadeOut {
                duration : 300, complete: -> generate_hackathon_table()
              }


generate_hackathon_table = ->
  console.log 'Generating hackathon table'
  # Current username
  username = window.user.username
  $.ajax \
    type: "POST",
    url: "hackathons/subscribed_to",
    data: {username : username},
    success: (data) ->
      $('#hackathon-table').html('').hide().append(data).fadeIn()
      $('#hackathon-table .minor').each ->
        $(this).click (e) ->
          id = $(this).attr('hack-id')
          $('#hackathon-table').fadeOut {
            duration : 300, complete: ->
              $('#hackathon-table').html('')
              load_hackathon_view(id)
          }
      console.log 'Appended table'

update_hackathons_if_needed = (callback) ->
  FB.api all_attending_events, (response) ->
    eids = (r.eid for r in response)
    # if any of the events the user is attending are in the
    # database, AND the user is not subscribed, then update database
    if eids.length == 0
      console.log 'No new hackathons for this user'
      if callback? then callback()
    else
      $.ajax \
        type: 'POST',
        url: '/get_hackathons_to_update.json',
        data: { eids : eids, username : window.user.username },
        dataType: 'json',
        success: (data) ->
          if data.status?
            console.log 'No new hackathons for this user'
            if callback? then callback()
          else
            console.log 'Need to update these'
            console.log data
            # if the server returned any eids, update user lists
            queries = {}
            for eid in eids
              queries[eid] = users_for_event_query(eid)
            query = {
              method: 'fql.multiquery'
              queries: queries
            }
            FB.api query, (data) ->
              $.ajax \
                type:'POST',
                url:'/update_hackathons_users.json',
                data: {hackathons : data},
                success: (data) ->
                  console.log data.status
                  if callback? then callback()



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

# Initiate the timepicker handle
setup_time_picker = () ->
  $('.time-in').datetimepicker {format : 'yyyy-mm-dd hh:ii'}
