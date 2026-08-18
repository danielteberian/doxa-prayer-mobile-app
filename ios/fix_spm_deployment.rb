#!/usr/bin/env ruby

require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "Fixing deployment targets for all targets..."

project.targets.each do |target|
  target.build_configurations.each do |config|
    current = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
    if current && current.to_f < 15.0
      puts "  #{target.name} (#{config.name}): #{current} -> 15.0"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end

# Also fix project-level build settings
project.build_configurations.each do |config|
  current = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
  if current && current.to_f < 15.0
    puts "  Project (#{config.name}): #{current} -> 15.0"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  end
end

project.save

puts "Done!"
