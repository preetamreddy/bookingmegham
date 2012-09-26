$ ->
  $('#booking_check_in_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#check_in_date_first').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
