$ -> 
  if $('#booking_chart').length > 0
    $('td').click -> 
      booking_id = $(this).attr('booking_id')
      if booking_id.length > 0
        window.open('/bookings/' + booking_id)
