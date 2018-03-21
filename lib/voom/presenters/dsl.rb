require 'voom/trace'

module Voom
  module Presenters
    def self.define(name, &block)
      DSL.define(name, &block)
    end

    module DSL
      class << self
        include Voom::Trace
      end

      @registry = {}

      def self.registry
        @registry
      end

      def self.define(name, &block)
        registry[name] = Voom::Presenters::DSL::Definition.new(&block)
      end

      def self.load(directory)
        files = File.join(directory, '**', '*.pom')
        Dir.glob(files) do |file|
          trace {"Loading Presenter: #{file}"}
          Kernel.load file
        end
      end

      def self.finalize
        registry.each do |key, definition|
          begin
            register(key, build(definition))
          rescue Exception => e
            logger.error {"Failed to load presenter #{key}: #{e.inspect}."}
            raise e
          end
        end
      end

      # This method empties out the dsl definitions
      # It should ONLY be used for testing purposes
      def self.reset!
        registry.clear
      end

      private

      def self.register(name, definition)
        return Voom::Presenters::App.register(name: name, presenter: definition) unless Voom::Presenters::App.registered?(name)
        logger.warn {"Warning attempted to redefine the presenter: #{name}!"}
      end

      def self.build(definition)
        definition.build
      end
    end
  end
end
