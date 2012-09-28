$ ->
  $('#payment_date_received').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#payments_search_from_date').datepicker(
    dateFormat: 'dd-M-yy'
  )
  $('#payments_search_to_date').datepicker(
    dateFormat: 'dd-M-yy'
  )
