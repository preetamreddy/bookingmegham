propertyparseDate = (inputDateString) ->
  inputDateArray = inputDateString.split("-")
  inputDateReformattedString = inputDateArray[1] + ' ' + inputDateArray[0] + ' ' + inputDateArray[2]
  new Date(inputDateReformattedString)

$ ->
  $('#availability_chart_start_date').datepicker(
    dateFormat: 'dd-M-yy'
  )
  $('#availability_chart_end_date').datepicker(
    dateFormat: 'dd-M-yy'
  )
  if $('#availability_chart').length > 0
    $('td')
      .click -> 
        room_type_id = $(this).attr('room_type_id')
        property_id = $(this).attr('property_id')
        date = $(this).attr('date')
        if room_type_id.length > 0
          window.open('/bookings/new?room_type_id=' + room_type_id + '&check_in_date=' + date)
        else
          if property_id.length > 0
            window.open('/bookings/new?property_id=' + property_id + '&check_in_date=' + date)
    $('form').submit ->
      chartStartDateString = $('#availability_chart_start_date').val()
      chartStartDate = parseDate(chartStartDateString)
      chartEndDateString = $('#availability_chart_end_date').val()
      chartEndDate = parseDate(chartEndDateString)
      numberOfDays = (chartEndDate - chartStartDate)/(1000*60*60*24)
      if numberOfDays < 1 or numberOfDays > 30
        alert 'Date range has to be between 1 to 30 days'
        return false
      else
        return true
