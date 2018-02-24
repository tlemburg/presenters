require_relative 'user_interface'

module Voom
  module Presenters
    module DSL
      # The default dsl for ui
      # You can override this using the UI.config.dsl.definition setting.
      # This class is held in the container. When a request to render a UI comes in
      # It creates a new UserInterface instance, binding it to the router and context of the request
      class Definition
        def initialize(&block)
          @block = block
        end

        def build
          self
        end

        def expand(router: , context:{}, &block)
          presenter = UserInterface.new(router: router, context: context,  &@block)
          yield(presenter) if block
          presenter.expand_instance
        end

        def expand_child(parent:, context: {})
          presenter = UserInterface.new(parent: parent, context: context, &@block)
          presenter.expand_instance(freeze: false)
        end
      end
    end
  end
end