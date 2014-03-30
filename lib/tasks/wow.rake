desc "This task prepares the system for production deployment"
task :wow do
  puts "Precompiling assets..."
  Rake::Task["assets:precompile"].invoke

  development_db_path = Dir.pwd + '/db/development.sqlite3'
  production_db_path = Dir.pwd + '/db/production.sqlite3'

  unless File.exists?(production_db_path)
  	puts "Creating production db from development db..."
  	FileUtils.cp development_db_path, production_db_path
  end
  
  puts "Done! Now run the command:"
  puts "$ rails s -e production"
end
