$ ->
  $('#trip_start_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#trip_invoice_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#accordion').accordion(
    { heightStyle: "content" }
  )
