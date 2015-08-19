# desc "Explaining what the task does"
# task :valogy do
#   # Task goes here
# end

namespace :valogy do

  desc "run parser with given path to ontolgy"
  task :translate, [:path] => [:environment] do |t, args|
    Valogy::Translator.parse(args.path)
  end
end
