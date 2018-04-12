require_relative 'input'

module Voom
  module Presenters
    module DSL
      module Components
        class HiddenField < Input

          def initialize(**attribs_, &block)
            super(type: :hidden_field, context: context,
                  **attribs_, &block)
            expand!
          end

          def value(value=nil)
            return @value if locked?
            @value = value
          end
        end
      end
    end
  end
end

