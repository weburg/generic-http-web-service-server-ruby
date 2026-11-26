require 'minitest/autorun'
require 'json'
require 'example/domain/omnibus'

class JsonSerializerTest < Minitest::Test
  def test_formats_local_and_offset_datetimes_with_six_fractional_digits
    omnibus = Omnibus.new
    omnibus.birthtime = Time.local(2016, 5, 11, 12, 0, 0)
    omnibus.sendtime = Time.utc(2026, 11, 23, 9, 52, 21.899647)

    result = JSON.parse(Ghowst::JsonSerializer.generate(omnibus))

    assert_equal '2016-05-11T12:00:00.000000', result.fetch('birthtime')
    assert_equal '2026-11-23T09:52:21.899647+00:00', result.fetch('sendtime')

    omnibus.sendtime = Time.new(2026, 11, 23, 9, 52, 21.899647, '-07:00')
    result = JSON.parse(Ghowst::JsonSerializer.generate(omnibus))
    assert_equal '2026-11-23T09:52:21.899647-07:00', result.fetch('sendtime')
  end

  def test_rejects_offset_time_in_localdatetime_field
    [Time.new(2016, 5, 11, 12, 0, 0, '-07:00'), Time.utc(2016, 5, 11, 12, 0, 0)].each do |time|
      omnibus = Omnibus.new
      omnibus.birthtime = time

      error = assert_raises(ArgumentError) { Ghowst::JsonSerializer.generate(omnibus) }
      assert_includes error.message, 'explicit UTC or fixed offset'
    end
  end
end
