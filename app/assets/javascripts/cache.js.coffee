cache = cache_timeouts = {
  user : null, invitees : null, attending_events : null, user_friends : null
  teams : null
}

cache_times = {   # in seconds
  user             : 60*60*1000  # 1 hour
  invitees         : 30*60*1000  # 30 minutes
  attending_events :  5*60*1000  # 5 minutes
  user_friends     : 15*60*1000  # 15 minutes
  teams            :  1*60*1000  # 1 minute
}

cache_getters = {
  user : (cb) -> FB.api user, (a) -> 
    time = new Date()
    v = {
      username : a[0].uid
      name : a[0].name
      email : a[0].email
    }
    cache.user = {v:v, time:time}
    #console.log "CACHE - DONE user"
    cb v
  attending_events : (cb) -> FB.api attending_events, (v) ->
    time = new Date()
    cache.attending_events = {v:v, time:time}
    #console.log "CACHE - DONE attending_events"
    cb v
  user_friends : (cb) -> FB.api '/me/friends', (v) ->
    time = new Date
    cache.user_friends = {v:v, time:time}
    #console.log "CACHE - DONE user_friends"
    cb v
  teams : (cb) -> 
    $.ajax { 
      type : 'GET'
      url : '/teams_for_hack'
      data : {eid : window.hackathon.eid} 
      success : (v) ->
        time = new Date
        cache.teams = {v:v, time:time}
        cb v
    }
}

make_timeout_f = (key) ->
  "window.get('#{key}', function(){console.log('CACHE - Auto refreshed #{key}')},true,true);"


window.get = (key, callback, now, suppress) ->
  suppress ?= true  # comment this out for easy cache debugging
  cache_entry = cache[key]
  # get the cache_entry, {value, timestamp}
  if not now? and cache_entry?
    if (new Date - cache_entry.time) > cache_times[key]
      now = true
    else 
      console.log "CACHE - GET #{key}" if not suppress?
      callback cache_entry.v
  if now or !(cache_entry?)
    console.log "CACHE - REFRESH #{key}" if not suppress?
    if cache_timeouts[key]?
      clearTimeout cache_timeouts[key]
    timeout_str = make_timeout_f key
    cache_timeouts[key] = \
      setTimeout(timeout_str,cache_times[key])
    cache_getters[key] callback

  $('html').data key, true

window.set = (key, v, cb) ->
  time = new Date()
  cache[key] = {v:v, time:time}
  cb()

#///////////////////////////////////////////////////////////////////
# Facebook pre-built queries
#///////////////////////////////////////////////////////////////////

user =
  method : 'fql.query'
  query : 'SELECT name, email, username, uid FROM user WHERE uid=me()'

attending_events = 
  method : 'fql.query'
  query : ('SELECT eid, name, description, pic_square, venue, location, start_time, end_time ' + 
          'FROM event WHERE eid IN (' +
          'SELECT eid FROM event_member ' +
          'WHERE uid = me() and rsvp_status="attending")')  # filter for attending only
          #'WHERE uid = me())')

