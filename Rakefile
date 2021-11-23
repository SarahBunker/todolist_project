require "rake/testtask"
require 'find'

desc 'Say hello'
task :hello do
  puts "Hello there. This is the 'hello' task."
end

desc 'Run tests'
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'list files except hidden files (starts with .) or directories that start with ..'
task :list_files do
  Find.find(".") do |name|
    next if name.include?('/.')
    puts name if File.file?(name)
  end
end