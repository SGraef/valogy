module Valogy
  class ObjectProperty
    attr_accessor :field, :name, :object, :inverse, :comments

    def initialize
      self.comments = []
    end

    def add_comment(comment)
      comments << comment
    end

  end
end
