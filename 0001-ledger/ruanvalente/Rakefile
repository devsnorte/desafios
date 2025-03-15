require 'rake'
require 'rake/testtask'

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

ENV['TEST'] = 'true'

Rake::TestTask.new do |t|
  t.pattern = 'lib/test/**/*_test.rb'
end

task default: :test
