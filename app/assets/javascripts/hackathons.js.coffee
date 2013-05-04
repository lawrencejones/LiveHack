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
      generate_hackathon_table()
      if callback? then callback()

show_new_hackathon_summary = (event_details) ->
  goback = $('<a href="#">Go Back</a>').click (e) ->
    e.preventDefault()
    get 'attending_events', (-> dismantle_new_hack_and_return()), true
  $('#processing-progress').hide()
  $('#form-tabs a:eq(2)').append $('<i/ class="icon-check">')
  $('#stage3-header').html('All done! ').append goback
  $('#stage3-caption').html("#{event_details.name} been created, happy hacking!")
  $('#stage3-caption').show()
  

hack_processing = (perc) ->
  $('#bar').animate {
    width : perc+'%'
  }, {duration : 75}

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
    $('#end-requirement-label').slideUp()

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
        if data.status == 'stop'
          create_event_warning_modal(event_data)
        else if $('#fbevent-select button:eq(0)').hasClass('btn-primary')
          $('#name').val event_data.name
          $('#start').val moment(event_data.start_time).format('HH:mm DD/MM/YYYY')
          if event_data.end_time?
            end_str = moment(event_data.end_time).format('HH:mm DD/MM/YYYY')
          else end_str = ''
          $('#end').val end_str
          $('#location').val event_data.location
          $('#desc-in').val event_data.description
          $('#stage1submit').removeClass('disabled')
          $('#end').attr 'readonly', 'readonly'
          $('#end').attr 'disabled', 'disabled'
          if $('#end').val() == ''
            $('#end').removeAttr 'readonly'
            $('#end').removeAttr 'disabled'
            $('#end-requirement-label').slideDown()
          else 
            $('#end').attr 'readonly', 'readonly'
            $('#end').attr 'disabled', 'disabled'
            $('#end-requirement-label').slideUp()
          window.selected_id = event_data.eid

  # Populate the event table with facebook events
  populate_event_table = () ->
    get 'attending_events', (r) ->
      for e in r
        top  = $('#event-row tr:eq(0)').clone()
        pic  = format_event_avatar(e.pic_square)

        name = $('<h5/ class="event-header">') \
          .addClass('push-up').html e.name
        s = moment(e.start_time)
        start = s.format('DD/MM/YYYY')
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
      $('.no').css 'height',$('.yes').height() + 15 + 'px'

  # Initialise button functionality
  sort_btns = () ->
    # set allowed tabbing properties to no for all
    $('#form-tabs a').each ->
      $(this).data('allowed',false)

    # for the submit button click
    $('#stage1submit').click ->
      if validate_inputs()
        [s,e] = [$('#start').val(), $('#end').val()].map (d)->
          d = moment(d, 'HH:mm DD/MM/YYYY').toDate()
        window.new_hackathon = 
        {
          access_token : window.fbtoken
          name : $('#name').val()
          start_time : s
          end_time : e
          description : $('#desc-in').val()
          location : $('#location').val()
          privacy : 'OPEN'
        }
        if $('#fbevent-select .btn-primary').text() == 'No'
          FB.api '/me/events/', 'post', window.new_hackathon, (response) ->
            window.new_hackathon.eid = response.id
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

    get 'user_friends', (r) -> 
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
          start : moment($('#schedule-start-in').val(), 'hh:mm DD/MM/YYYY').toDate()
          font : $('#font-input').val()
        $('.schedule-item-form input').val('')
        update_schedule_item_table(window.new_hackathon.schedule_items)

    $('#finish-new-hack').click -> 
      if !$(this).hasClass 'disabled'
        $(this).addClass 'disabled'
        $('.stage3-only').animate {opacity : 0}, {
          duration : 300, complete: ->\
            $('.stage3-only').slideUp()
        }
        $('#processing-progress').fadeIn(100)
        $('#stage3-header').html('Processing Hackathon...')
        $('#stage3-caption').hide()
        add_hackathon window.new_hackathon, hack_processing, \
          show_new_hackathon_summary

  # refresh table with contents of items
  update_schedule_item_table = (items) ->
    $('#sch-item-table .item').remove()
    items.sort (a,b) -> a.start - b.start
    for item in items
      $('#sch-item-row-template .sch-label').html item.label
      s = moment(item.start)
      console.log item.start
      $('#sch-item-row-template .time').html \
        '<b>' + s.format('HH:mm') + ' on ' + s.format('dddd, Do') + '</b>'
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
              console.log 'Appended new hack setup'
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

  initiate_login = ->
    $('#login-btn').click ->
      FB.login \
        check_login_result,
        {scope : 'user_events,email,read_friendlists,create_event,rsvp_event'}


  FB.getLoginStatus (response) ->
    if response.status is "connected"
      window.fbtoken = response.authResponse.accessToken
      console.log "Connected to facebook"
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

logged_in = ->
  # Hide the login button, no longer needed
  $('#login-btn').hide()
  $('#initial-subheading').hide()
  $('#logged-in-subheading').show()
  # Add the user if they are not already in the system
  get 'user', (user) ->
    add_user user, ask_for_sign_up


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
        end = moment(window.hackathon.end).format('DD/MM/YYYY')
        window.initialise_clock end

#///////////////////////////////////////////////////////////////////
# Reuseable Partials
#///////////////////////////////////////////////////////////////////

generate_hackathon_table = ->

  setup_hackathon_table_links = ->
    $('#hackathon-table .minor').each ->
      $(this).click (e) ->
        id = $(this).attr('hack-id')
        $('#hackathon-table').fadeOut {
          duration : 300, complete: ->
            $('#hackathon-table').html('')
            load_hackathon_view(id)
        }
  get 'attending_events', (response) ->
    eids = (r.eid for r in response)
    get 'user', (user) ->
      request = {
        username : user.username
        eids : eids
      }
      $.ajax \
        type: "POST",
        url: "hackathons/subscribed_to",
        data: request,
        success: (data) ->
          $('#hackathon-table').html('').hide().append(data).fadeIn()
          eids = []
          $('#hackathon-table tr[class="minor"]').each ->
            eids.push @.getAttribute 'hack-eid'
          #if $('#hackathon-table tbody').attr('needs-update') is 'true'
          update_rails_hackathons(eids) 

ask_for_sign_up = (user) ->
  if user.signed_up?
    generate_hackathon_table()
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
        get 'user', (user) ->
          user.github_email = $('#github-in').val()
          skills = []
          $('#skills span').each -> skills.push $(this).html()
          user.tags = skills.toString()
          user.signed_up = true
          set 'user', user, ->
            $.ajax \
              type: 'POST',
              url: '/users.json',
              data: {user : user, giving_details : true},
              dataType : 'json',
              success: (data) ->
                if data.github_email == user.github_email
                  # it all worked
                  $('#save-details').html('Success!')
                  $('#user-details-form').delay(300).fadeOut {
                    duration : 300, complete: -> 
                      generate_hackathon_table()
                  }

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
      if callback? then callback(data)

add_hackathon = (hack,in_situ,callback) ->
  post_to_rails = (i,users) ->
    packet_size = 400
    hack.users = users[i*packet_size..(i+1)*packet_size-1]
    $.ajax \
      type: 'POST',
      url: '/hackathons.json',
      data: {hackathon : hack},
      dataType: 'json',
      success: (data) ->
        in_situ 100*((i+1)*packet_size-1)/users.length
        if users.length > (i+1)*packet_size-1
          post_to_rails i+1, users
        else
          console.log "Posted hackathon #{hack.name}"
          if data.status != 'failed'
            hack.users = users
            if callback? then callback(hack)

  FB.api "/#{hack.eid}/invited", (r) ->
    users = r.data
    console.log typeof (new Date(hack.start_time))
    console.log typeof 'hey'
    post_to_rails 0, users

update_rails_hackathons = (eids) ->
  users_for_event_query = (eid) ->
    'SELECT uid, name FROM user WHERE uid IN (' +
    "  SELECT uid FROM event_member WHERE eid = \"#{eid}\")"

  console.log 'Updating rails hackathon data'
  queries = {}  
  if eids? then for eid in eids
    queries[eid] = users_for_event_query(eid) 
  FB.api {method: 'fql.multiquery', queries : queries}, (data) ->
    $.ajax \
      type: 'POST',
      data: {events : data},
      url: '/update_users.json'
      success: (response) ->
        console.log response


#///////////////////////////////////////////////////////////////////
# Utilities
#///////////////////////////////////////////////////////////////////

js_date_to_fb_date = (d) ->
  return d.toISOString().split('.')[0]+'-0000'

format_event_avatar = (url) ->
   $("<img/ src=\"#{url}\">").addClass('event-img')

# Initiate the timepicker handle
setup_time_picker = () ->
  $('.time-in').datetimepicker {format : 'hh:ii dd/mm/yyyy'}
