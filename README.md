# cocoapods-time-analyze

cocoapods-time-analyze is used to display the time spent by every step of  `pod install` and total time of xcode build.

## Installation

```shell
$ gem install cocoapods-time-analyze
# if you use bundle
$ bundle add cocoapods-time-analyze
```

Then add this to your podfile:

```ruby
plugin 'cocoapods-time-analyze'
```

Then run `pod install`.

## Usage

### Pod install time analyze

Create the `.cocoapods_time_analyze_config.rb` file under the Podfile  directory.

Use this file to config the behaviour.

```ruby
module TimeAnalyzeConfig
  class PodInstall
    # by default the plugin will generate a summary yaml file named pod-install-summary.yml under directory, you can
    # use this method to override this behaviour
    def self.enable_local_summary
      true
    end
    # add the step you want to analyze to this method
    def self.target_steps
      %w[prepare resolve_dependencies generate_pods_project]
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
end
```

### Build time analyze

Open Xcode, add this script to the post build action of scheme you want to analyze:

```shell
# script in xcode scheme post build action does not display 
# in the xcode console, so we need to save it to a log file.
exec > $PODS_ROOT/cocoapods-time-analyze-post-build.log 2>&1
ruby $PODS_ROOT/analyze_build.rb
```

If you want to config the behaviour, you can also open the `.cocoapods_time_analyze_config.rb` file to config it.

```ruby
module TimeAnalyzeConfig
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
```

