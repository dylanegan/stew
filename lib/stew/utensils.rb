module Stew
  module Utensils
    def stew(options = {}, &block)
      Stew::Server.new(options, &block)
    end
  end
end
