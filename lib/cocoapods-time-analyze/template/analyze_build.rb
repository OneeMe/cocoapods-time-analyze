require 'json'
require 'yaml'

workspace_dir = ENV['BUILD_DIR'].gsub('Build/Products', '')
build_log_path = File.join(workspace_dir, 'Logs/Build/LogStoreManifest.plist')
app_path = ENV['CODESIGNING_FOLDER_PATH']
executable_path = File.join(app_path, File.basename(app_path, '.app'))
pods_root = ENV['PODS_ROOT']
config_dir = File.dirname(pods_root)
config_file_path = File.join(config_dir, '.cocoapods_time_analyze_config.rb')

load config_file_path

# call Dir.mktmpdir in scheme post action script may throw can not find method exception
json_log_file = `mktemp`.strip

`plutil -convert json -o #{json_log_file} #{build_log_path}`
log_content = JSON.parse(File.read(json_log_file))
`rm -rf #{json_log_file}`

end_time_with_duration = log_content['logs'].each_with_object({}) do |log_content, hash|
  start_timestamp = log_content.last.values.first['timeStartedRecording'].to_i
  end_timestamp = log_content.last.values.first['timeStoppedRecording'].to_i
  duration = end_timestamp - start_timestamp
  hash[end_timestamp] = duration
end

last_build_duration = end_time_with_duration[end_time_with_duration.keys.sort.last]
executable_size = File.size(executable_path)
otherthing_size = File.size(app_path) - executable_size

TimeAnalyzeConfig::Build.after_all(last_build_duration, { binary_size: executable_size, other_size: otherthing_size })

if TimeAnalyzeConfig::Build.enable_local_summary
  file_name = 'build-summary.yml'
  file_path = File.join(config_dir, file_name)
  today = Date.today.to_s
  summary_total_time = last_build_duration.to_i
  summary = File.exist?(file_name) ? YAML.safe_load(File.read(file_name)) : {}
  summary['total_time'] = summary['total_time'] ? summary['total_time'] + summary_total_time : summary_total_time
  summary['detail'] ||= {}
  summary['detail'][today] = summary['detail'][today] ? summary['detail'][today] + summary_total_time : summary_total_time
  File.open file_path, 'w+' do |file|
    file.write(YAML.dump(summary))
  end
end
