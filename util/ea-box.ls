module.exports = class Ea-box extends require './abstract-data-entry'
  @id = 1
  (@name, @billing-status)->
    super ...
    @product-info = 
      rpi-serial: @@@get-random-serial!
      ea-box-version: '1.0'
      release-date: @@@get-random-datetime-between -100.1, 100
    @working-status = 'idle'

