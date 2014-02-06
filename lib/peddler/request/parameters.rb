require 'delegate'
require 'time'

require 'peddler/request/structured_list'

module Peddler
  class Request
    class Parameters < SimpleDelegator
      def initialize(action)
        super('Action' => action)
      end

      def timestamp!
        each do |key, value|
          store(key, value.iso8601) if value.respond_to?(:iso8601)
        end

        self
      end

      def format_structured_lists!(options = {})
        lists = {}
        skip = options.delete(:skip).to_a
        each do |key, value|
          next if skip.include?(key)
          if StructuredList.handle?(key)
            list = StructuredList.new(key).build(delete(key))
            lists.update(list)
          end
        end

        update(lists)
      end

      def camelize_keys!
        keys.each do |key|
          if key.is_a?(Symbol)
            new_key = camelize(key)
            store(new_key, delete(key))
          end
        end

        self
      end

      def update(hsh)
        __getobj__.update(hsh)
        self
      end

      private

      def camelize(sym)
        sym.to_s.split('_').map(&:capitalize).join
      end
    end
  end
end
