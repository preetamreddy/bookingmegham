parseDate = (inputDateString) ->
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
