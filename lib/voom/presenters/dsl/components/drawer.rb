require_relative 'mixins/common'
require_relative 'mixins/attaches'

module Voom
  module Presenters
    module DSL
      module Components
        class Drawer < Base
          include Mixins::Common
          include Mixins::Attaches

          attr_accessor :title, :components

          def initialize(**attribs_, &block)
            super(type: :drawer, **attribs_, &block)
            self.title(attribs.delete(:title)) if attribs.key?(:title)
            @components = []

            expand!
          end

          def menu(**attribs, &block)
            return @menu if locked?
            @menu = Menu.new(parent: self, context: context,
                             **attribs, &block)
          end

          def attach(presenter, **params, &block)
            pom = super
            @menu = pom.components.select {|i| i.type==:menu}.first
          end

          def title(*text, **attribs, &block)
            return @title if locked?
            @title = Components::Typography.new(parent: self, type: :text, text: text, context: context, **attribs, &block)
          end

        end
      end
    end
  end
end
