Pod::HooksManager.register('cocoapods-time-analyze', :post_install) do |installer|
  analyze_template_file_path = File.expand_path '../template/analyze_build.rb', __dir__
  FileUtils.copy analyze_template_file_path, installer.sandbox.root.to_s
end
