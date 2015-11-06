module Valogy
  require 'nokogiri'
  require 'valogy/data_property'
  require 'valogy/object_property'
  require 'valogy/entity'
  require 'valogy/axiom'
  require 'valogy/comment'
  require 'valogy/translator'
  require 'valogy/restriction'
  require 'valogy/restrictions/existence_restriction'
  require 'valogy/restrictions/exactly_restriction'
  require 'valogy/restrictions/maximal_restriction'
  require 'valogy/restrictions/minimal_restriction'
  require 'valogy/base_model'
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/valogy_tasks.rake'
    end
  end
end
