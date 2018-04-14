module Voom
  module Presenters
    module DSL
      module Components
        module Mixins
          module Selects
            def select(**attribs, &block)
              self << Components::Select.new(parent: self,
                                             context: context,
                                             **attribs, &block)
            end
          end
        end
      end
    end
  end
end
