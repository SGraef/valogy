module Valogy
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_controller
        copy_file "valogy_controller.rb", "app/controllers/valogy_controller.rb"
      end

      def add_views
        view_suffix = Rails.application.config.generators.
        options[:rails][:template_engine] || "erb"
        copy_file "valogy_new.html.#{view_suffix}", "app/views/valogy/new.html.#{view_suffix}"
      end

      def route_valogy
        route "get 'valogy/new/', to: 'valogy#new'"
        route "post 'valogy/create/', to: 'valogy#create'"
      end
    end
  end
end
