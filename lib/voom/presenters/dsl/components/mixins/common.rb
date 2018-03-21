require_relative 'append'
require_relative 'switches'
require_relative 'typography'
require_relative 'grid'
require_relative 'buttons'

module Voom
  module Presenters
    module DSL
      module Components
        module Mixins
          module Common
            include Mixins::Switches
            include Mixins::Append
            include Mixins::Typography
            include Mixins::Grid
            include Mixins::Buttons

            def badge(badge=nil, **attributes, &block)
              self << Components::Badge.new(parent: self, badge: badge, context: context, **attributes, &block)
            end

            def card(**attributes, &block)
              self << Components::Card.new(parent: self, context: context, **attributes, &block)
            end

            def form(id: nil, **attributes, &block)
              self << Components::Form.new(parent: self, id: id, context: context, **attributes, &block)
            end

            def list(**attributes, &block)
              self << Components::List.new(parent: self,
                                           context: context, **attributes, &block)
            end

            def menu(**attributes, &block)
              self << Components::Menu.new(parent: self, context: context, **attributes, &block)
            end

            def table(**attributes, &block)
              self << Components::Table.new(parent: self, context: context, **attributes, &block)
            end
          end
        end
      end
    end
  end
end
