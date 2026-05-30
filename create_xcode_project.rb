#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'PlantTycoon.xcodeproj'
project = Xcodeproj::Project.new(project_path)

# Create main target
target = project.new_target(:application, 'PlantTycoon', :ios, '16.0')

# Add source files
main_group = project.main_group
plant_tycoon_group = main_group.new_group('PlantTycoon')

# Add all Swift files
Dir.glob('PlantTycoon/**/*.swift').each do |file|
  file_ref = plant_tycoon_group.new_reference(file)
  target.add_file_references([file_ref])
end

# Save project
project.save

puts "✅ Xcode project created successfully!"
