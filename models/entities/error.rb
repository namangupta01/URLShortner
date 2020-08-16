module Entities
  class Error
    attr_accessor :code, :message

    def initialize code, message
      self.code = code
      self.message = message
    end
  end
end