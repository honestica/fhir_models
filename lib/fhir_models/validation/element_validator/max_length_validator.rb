module FHIR
  module Validation
    # Validate that strings do not exceed the specified max length
    module MaxLengthValidator
      # @param element [Object] The Element of the Resource under test
      # @param element_definition [FHIR::ElementDefinition] The Element Definition from which the max length is derived
      # @return result [FHIR::ValidationResult] The result of the max length check
      def self.validate(resource, element_definition)
        return if element_definition.maxLength.nil?

        elements = Retrieval.retrieve_by_element_definition(resource,
                                                            element_definition,
                                                            indexed: true)

        elements.flat_map do |path, el|
          validate_element(el, element_definition, path)
        end
      end

      def self.validate_element(element, element_definition, path)
        FHIR::ValidationResult.new(element_definition: element_definition,
                                   validation_type: :max_length,
                                   element_path: path,
                                   element: element,
                                   result: element.length <= element_definition.maxLength ? :pass : :fail)
      end
    end
  end
end
