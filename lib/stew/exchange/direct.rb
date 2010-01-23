module Stew
  module Exchange
    class Direct < Base
      def key
        @options[:key]
      end
    end
  end
end
