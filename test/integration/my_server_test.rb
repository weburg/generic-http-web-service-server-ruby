require 'minitest/autorun'
require 'net/http'

class MyServerTest < Minitest::Test
  def test_my_server
    uri = URI("http://localhost:8081/generichttpws")
    request = Net::HTTP::Get.new(uri)

    result = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    assert_equal result.code, "200"
    assert_includes result.body, "Service description here."
  end
end