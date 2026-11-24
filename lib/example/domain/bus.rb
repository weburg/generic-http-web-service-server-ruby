# frozen_string_literal: true

class Bus
  attr_accessor :color

  def initialize(callsign)
    @callsign = callsign
    @color = 'yellow'
  end
end