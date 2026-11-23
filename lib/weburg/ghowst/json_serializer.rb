# frozen_string_literal: true

require 'json'
require 'time'

module Ghowst
  module JsonFields
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def ghowst_field(name, type:)
        @ghowst_fields ||= {}
        @ghowst_fields[name.to_sym] = type
      end

      def ghowst_fields
        inherited_fields = superclass.respond_to?(:ghowst_fields) ? superclass.ghowst_fields : {}
        inherited_fields.merge(@ghowst_fields || {})
      end
    end
  end

  module JsonSerializer
    module_function

    def generate(object)
      field_types = object.class.respond_to?(:ghowst_fields) ? object.class.ghowst_fields : {}
      public_methods = (object.class.public_instance_methods + object.public_methods(false)).map(&:to_s).uniq
      accessor_fields = public_methods.each_with_object([]) do |setter, result|
        next unless setter.end_with?('=')

        name = setter.delete_suffix('=')
        next unless name.match?(/\A[a-zA-Z_]\w*\z/)
        next unless public_methods.include?(name)
        next unless object.public_method(name).arity.zero? && object.public_method(setter).arity == 1

        result << name
      end
      readable_fields = object.instance_variables.map { |ivar| ivar.to_s.delete_prefix('@') }
                                                .select { |name| object.respond_to?(name) }
      field_names = (readable_fields + accessor_fields).uniq

      fields = field_names.each_with_object({}) do |field_name, result|
        name = field_name.to_sym
        value = object.public_send(name)
        result[name] = format_value(value, field_types.fetch(name, :json), name)
      end

      JSON.generate(fields)
    end

    def format_value(value, type, name)
      return nil if value.nil?

      case type
      when :json
        value
      when :localdatetime
        format_localdatetime(value, name)
      when :offsetdatetime
        format_offsetdatetime(value, name)
      else
        raise ArgumentError, "Unsupported GHoWSt field type #{type.inspect} for #{name}"
      end
    end
    private_class_method :format_value

    def format_localdatetime(value, name)
      unless value.is_a?(Time)
        raise TypeError, "#{name} must be a Time for localdatetime, got #{value.class}"
      end

      if value.utc? || value.zone.nil?
        raise ArgumentError, "#{name} is localdatetime but contains an explicit UTC or fixed offset"
      end

      value.strftime('%Y-%m-%dT%H:%M:%S.%6N')
    end
    private_class_method :format_localdatetime

    def format_offsetdatetime(value, name)
      unless value.is_a?(Time)
        raise TypeError, "#{name} must be a Time for offsetdatetime, got #{value.class}"
      end

      value.strftime('%Y-%m-%dT%H:%M:%S.%6N%:z')
    end
    private_class_method :format_offsetdatetime
  end
end
