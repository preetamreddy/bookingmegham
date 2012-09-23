$ ->
  $('#payment_date_received').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
