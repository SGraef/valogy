module Valogy
  module Generators
    class TaskGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_rake_task
        copy_file "valogy_tasks.rake", "lib/tasks/valogy.rake"
      end

    end
  end
end
