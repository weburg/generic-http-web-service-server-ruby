# frozen_string_literal: true

require 'weburg/ghowst/json_serializer'

class Omnibus
  include Ghowst::JsonFields

  attr_accessor :birthtime,
                :sendtime,
                :toppings,
                :sides,
                :onFire,
                :document,
                :pairing

  ghowst_field :birthtime, type: :localdatetime
  ghowst_field :sendtime, type: :offsetdatetime

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
