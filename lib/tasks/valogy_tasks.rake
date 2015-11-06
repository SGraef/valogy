namespace :valogy do

  desc "run translator with given path to ontolgy"
  task :translate, [:path] => [:environment] do |t, args|
    Valogy::Translator.parse(args.path)
  end

  desc "remove valogy constraints and functions from database"
  task :remove => :environment do
    translator = Valogy::Traslatort.new()
    translator.clean_database
  end
end
