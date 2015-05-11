module Valogy
  class DataProperty
    attr_accessor :column, :name, :datatype, :axioms, :comments

    def initialize
      self.comments = []
    end

    def axioms
      @axioms || {}
    end

    def add_comment(comment)
      comments << comment
    end

  end
end
