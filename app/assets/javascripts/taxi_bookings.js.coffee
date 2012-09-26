$ ->
  $('#taxi_booking_start_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#taxi_bookings_search_start_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
