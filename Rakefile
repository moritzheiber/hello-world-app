require 'bundler/setup'
require 'autostacker24'

SERVICE  = 'hello-world'
VERSION  = ENV['VERSION'] || ENV['SNAP_PIPELINE_COUNTER']
SANDBOX  = ENV['SANDBOX'] || ENV['SNAP_STAGE_NAME'].nil? && `whoami`.strip
STACK    = SANDBOX ? "#{SANDBOX}-#{SERVICE}" : SERVICE
TEMPLATE = File.read("#{SERVICE}-stack.json")

desc 'create or update stack'
task :create_or_update do
  parameters = {
    AmiId: 'ami-46272b5b', # Ubuntu 14.04.3 LTS
    Service: SERVICE,
    Version: VERSION
  }
  Stacker.create_or_update_stack(STACK, TEMPLATE, parameters)
end

desc 'deploy the app'
task :deploy => [:create_or_update] do
end

desc 'delete stack'
task :delete do
  Stacker.delete_stack(STACK)
end

desc 'validate template'
task :validate do
  Stacker.validate_template(TEMPLATE)
end

desc 'dump template'
task :dump do
    puts JSON.pretty_generate(JSON(Stacker.template_body(TEMPLATE)))
end

task :default do
  puts
  puts 'Use one of the available tasks:'
  puts "Current stack is #{STACK}\n"
  system 'rake -T'
end
