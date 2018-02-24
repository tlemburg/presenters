module Voom
  module Presenters
    module DSL
      module Components
        module MixinAppend

          def <<(comp)
            @components << comp
          end
          
          def yield_to
            instance_eval(&@parent.yield_block) if @parent.yield_block
          end
        end
      end
    end
  end
end
