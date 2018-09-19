require 'cocoapods-time-analyze/config-loader/config_loader'
require 'cocoapods-time-analyze/const'
require 'yaml'

module Pod
  class Installer
    alias origin_install! install!

    def install!
      @time_log = {}

      TimeAnalyzeConfig::PodInstall.target_steps.each { |step| redefine_step_method(step.to_sym) }
      install_start_time = Time.now
      origin_install!
      total_time = Time.now - install_start_time

      TimeAnalyzeConfig::PodInstall.after_all(total_time, @time_log)
      write_summary_file(total_time) if TimeAnalyzeConfig::PodInstall.enable_local_summary
    end

    def self.alias_step_method(method_sym)
      if method_defined?(method_sym)
        alias_method "origin_#{method_sym}".to_sym, method_sym
      else
        UI.puts "Pod::Installer does not have method named #{method_sym}, please check your .cocoapods_time_analyze.rb config file"
      end
    end

    private

    def redefine_step_method(method_sym)
      @time_log ||= {}

      block = proc do |*arguments|
        start_time = Time.now
        send("origin_#{method_sym}".to_sym, *arguments)
        total_time = Time.now - start_time
        @time_log[method_sym] = total_time
      end

      self.class.alias_step_method(method_sym)
      self.class.send(:define_method, method_sym, &block)
    end

    def write_summary_file(total_time)
      file_name = PodTimeAnalyze::POD_INSTALL_SUMMARY_FILE_NAME
      today = Date.today.to_s
      summary_total_time = total_time.to_i
      summary = File.exist?(file_name) ? YAML.safe_load(File.read(file_name)) : {}
      summary['total_time'] = summary['total_time'] ? summary['total_time'] + summary_total_time : summary_total_time
      summary['detail'] ||= {}
      summary['detail'][today] = summary['detail'][today] ? summary['detail'][today] + summary_total_time : summary_total_time
      File.open file_name, 'w+' do |file|
        file.write(YAML.dump(summary))
      end
    end
  end
end
