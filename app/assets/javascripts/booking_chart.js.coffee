$ -> 
  if $('#booking_chart').length > 0
    $('td')
      .click -> 
        booking_id = $(this).attr('booking_id')
        room_type_id = $(this).attr('room_type_id')
        date = $(this).attr('date')
        if booking_id.length > 0
          window.open('/bookings/' + booking_id)
        else
          if room_type_id.length > 0
            window.open('/bookings/new?room_type_id=' + room_type_id + '&check_in_date=' + date)
