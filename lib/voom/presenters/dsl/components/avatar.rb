require_relative 'mixins/event'

module Voom
  module Presenters
    module DSL
      module Components
        class Avatar < Base
          include Mixins::Event

          attr_accessor :avatar, :color, :size

          def initialize(**attribs_, &block)
            super(type: :avatar, context: context,
                  **attribs_, &block)
            @avatar = attribs.delete(:avatar)
            @color = attribs.delete(:color)
            @size = attribs.delete(:size)
            expand!
          end
        end
      end
    end
  end
end
