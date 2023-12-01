require "fileutils"
require "test/unit"
require 'colorize'

task :default => :test

task :test do
  Dir.glob("./**/*.spec.rb").each { |file| require file }
end

task :validate_day_creation, [:arg1] do |t, args|
  path = args[:arg1]

  print "Validating "
  print path.green
  puts "..."

  Dir.glob("./#{path}/**/*.spec.rb").each { |file| require file }

  puts "All set ✅"
  puts "Happy hacking! 🚀"
end

task :create_day, [:arg1] do |t, args|
  day_number = args[:arg1]
  dest = "day-#{day_number}"

  print "Creating "
  print dest.green
  puts "..."

  FileUtils.mkdir_p(dest)

  print "Copying files from template dir into "
  print dest.green
  puts "..."

  %w[data lib test].each do |dir|
    FileUtils.mkdir_p("#{dest}/#{dir}")
    print "Copying "
    puts "/#{dir}...".blue
    FileUtils.cp_r("_templates/day-template/#{dir}", dest)
  end

  print "Copying "
  puts "/README.md...".blue
  FileUtils.copy_file('_templates/day-template/README.md', File.join(dest, 'README.md'))

  Rake::Task["validate_day_creation"].invoke dest
end
