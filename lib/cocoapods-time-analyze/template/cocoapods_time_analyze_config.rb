module TimeAnalyzeConfig
  class PodInstall
    # by default the plugin will generate a summary yaml file named pod-install-summary.yml under directory, you can
    # use this method to override this behaviour
    def self.enable_local_summary
      true
    end

    # add the step you want to analyze to this method
    def self.target_steps
      %w[]
    end

    # do anything you want to do after pod install, for example, you can send the result to a server
    # this method will be executed in the directory the `pod install` command called.
    # @param total_time [Float] pod install total time, in second
    # @param detail [Hash] analyze result in hash format, the key is the step name, value is the duration in second.
    # @param installer [Pod::Installer] instance of Pod::Installer of this install process
    def self.after_all(total_time, detail, installer)
      # something awesome
    end
  end

  class Build
    # by default the plugin will generate a summary yaml file named build-summary.yml under directory, you can
    # use this method to override this behaviour
    def self.enable_local_summary
      true
    end

    # do anything you want to do after build, for example, you can send the result to a server
    # this method will be executed under Xcode derived data directory, and you can use ENV to
    # fetch environment variables of xcode build
    # @param total_time [Float] build total time, in second
    # @param detail [Hash] analyze result in hash format
    # @option opts [Integer] :binary_size The size of the binary in final .app product
    # @option opts [Integer] :other_size The size of things except binary size in final .app product
    def self.after_all(total_time, detail)
      # something awesome
    end
  end
end
