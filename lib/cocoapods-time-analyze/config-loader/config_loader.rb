if File.exist?('./.cocoapods_time_analyze_config.rb')
  load File.expand_path('./.cocoapods_time_analyze_config.rb')
else
  require 'cocoapods-time-analyze/template/cocoapods_time_analyze_config'
end
