require 'test_helper'

class TripNotifierTest < ActionMailer::TestCase
  test "details" do
    mail = TripNotifier.details
    assert_equal "Details", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "invoice" do
    mail = TripNotifier.invoice
    assert_equal "Invoice", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "receipt" do
    mail = TripNotifier.receipt
    assert_equal "Receipt", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "voucher" do
    mail = TripNotifier.voucher
    assert_equal "Voucher", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
