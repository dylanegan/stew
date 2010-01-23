module Stew
  module Exchange
    class Topic < Base
      def key
        @options[:key]
      end
    end
  end
end
