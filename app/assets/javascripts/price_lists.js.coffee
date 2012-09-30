propertySelected = ->
  property_id = $('#property_id').val()
  if property_id.length == 0
    $('#room_type_id')
      .find('option')
      .remove()
      .end()
      .hide()
    $("label[for='room_type_id']").hide()
    $('#meal_plan').hide()
    $("label[for='meal_plan']").hide()
  else
    $('#room_type_id').show()
    $("label[for='room_type_id']").show()
    $('#meal_plan').show()
    $("label[for='meal_plan']").show()

$ ->
  $('#price_list_start_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  $('#price_list_end_date').datepicker(
    dateFormat: 'dd-M-yy'
    onClose: ->
      this.focus()
  )
  if $('#price_list_search').length > 0
    propertySelected()
    $('#property_id').change ->
      property_id = $('#property_id').val()
      if property_id.length > 0
        $.get("/properties/#{property_id}/room_types_by_property")
      propertySelected()
    $('form').submit ->
      property_id = $('#property_id').val()
      if property_id.length == 0
        alert 'Property has to be selected'
        return false
      else
        return true
