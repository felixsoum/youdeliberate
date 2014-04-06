# encoding: utf-8
if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

desc "This task prepares the system for production deployment"
task :wow do
  puts "Precompiling assets..."
  Rake::Task["assets:precompile"].invoke

  development_db_path = Dir.pwd + "/db/development.sqlite3"
  production_db_path = Dir.pwd + "/db/production.sqlite3"

  unless File.exists?(production_db_path)
  	puts "Creating production db from development db..."
  	FileUtils.cp development_db_path, production_db_path
  end
  
  puts "Done! Now run: rails s -e production"
end
