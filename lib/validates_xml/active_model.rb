require 'validates_xml'
require 'active_model'

module ActiveModel
  module Validations
    class XmlValidator < EachValidator
      def validate_each(record, attribute, value)
        xml_content = value

        if defined?(::CarrierWave) && value.is_a?(::CarrierWave::Uploader::Base)
          xml_content = record.send(attribute).read
        end

        validator = ValidatesXml::Validator.new(xml_content, options)
        error = validator.validate

        return if error.blank?

        record.errors.add(attribute, error)
      end
    end

    module HelperMethods
      def validates_xml_of(*attr_names)
        validates_with XmlValidator, _merge_attributes(attr_names)
      end
    end
  end
end
