if File.exist?('./cocoapods_time_analyze.rb')
  load File.expand_path('./cocoapods_time_analyze.rb')
else
  require 'cocoapods-time-analyze/template/cocoapods_time_analyze'
end
