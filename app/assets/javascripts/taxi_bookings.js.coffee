$ ->
  $('#taxi_booking_start_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#taxi_bookings_search_from_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#taxi_bookings_search_to_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
