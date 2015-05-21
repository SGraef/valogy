module Valogy
  class BaseModel < ActiveRecord::Base
    @abstract_class = true
    after_save :set_consistency, unless: :consistent?
    include Valogy::Query

    def set_consistency
      self.consistent = true
      self.save
    rescue ActiveRecord::StatementInvalid => e
      validation = e.message.match('check\ constraint\ \\"([\S]*)\\"')[1]
      if validation.include?("valogy")
				error_string = I18n.t("valogy.#{validation}")
				self.errors[I18n.t("valogy.model.#{validation}").to_sym] << error_string
				raise(ActiveRecord::RecordInvalid.new(self))
			else
				raise(e)
			end
    end


    def consistent?
      self.consistent
    end


  end
end
