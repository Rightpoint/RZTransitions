PROJ_PATH="RZTransitions-Demo/RZTransitions-Demo.xcodeproj"
DEMO_OBJC="RZTransitions-Demo"
DEMO_SWIFT="RZTransitions-Demo-Swift"

#
# Install
#
task :install do
  # don't care if this fails on travis
  sh("brew update") rescue nil
  sh("brew upgrade xctool") rescue nil
end

#
# Build
#
task :build do
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_OBJC}' -sdk iphonesimulator build") rescue nil
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_SWIFT}' -sdk iphonesimulator build") rescue nil
  exit $?.exitstatus
end

#
# Analyze
#

task :analyze do
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_OBJC}' -sdk iphonesimulator analyze -failOnWarnings") rescue nil
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_SWIFT}' -sdk iphonesimulator analyze -failOnWarnings") rescue nil
  exit $?.exitstatus
end

#
# Clean
#

task :clean do
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_OBJC}' -sdk iphonesimulator clean") rescue nil
  sh("xctool -project '#{PROJ_PATH}' -scheme '#{DEMO_SWIFT}' -sdk iphonesimulator clean") rescue nil
end

#
# Default
#

task :default => 'build'
