module.exports = class Abstract-data-entry
  @get-random-serial = -> Math.random! * 10 ^ 16

  @get-random-datetime-between = (start, end)->
    start = @convert-to-date start
    end = @convert-to-date end
    @_get-random-datetime-between start, end

  @A_DAY = 24h * 60m * 60s * 1000ms
  @FIFTY_YEARS = 50y * 365d 
  @convert-to-date = (datetime)->
    return datetime if datetime instanceof Date
    return the-time-before = new Date ((new Date - 0) + @A_DAY * datetime) if typeof datetime is 'number' and Math.abs datetime < @FIFTY_YEARS
    return new Date datetime if typeof datetime is 'number'
    throw new Error "can't create date for: ", datetime

  @_get-random-datetime-between = (start, end)-> 
    # console.log "start: ", start
    # console.log "end: ", end
    start - 0 + Math.random! * (end - start)
    # new Date (start - 0 + Math.random! * (end - start))

  ->
    @_id = @@@id++




