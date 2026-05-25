# frozen_string_literal: true

class Omnibus
  attr_accessor :birthtime,
                :sendtime,
                :toppings,
                :sides,
                :onFire,
                :document,
                :pairing

  def initialize
    @birthtime = nil
    @sendtime = nil
    @toppings = []
    @sides = []
    @onFire = false
    @document = nil
    @pairing = []
  end
end
