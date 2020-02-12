require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-motion-activity"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-motion-activity
                   DESC
  s.homepage     = "https://github.com/kora-app/react-native-motion-activity"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = package['contributors'].flat_map { |author| { author['name'] => author['email'] } }
  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/kora-app/react-native-motion-activity.git", :tag => "#{s.version}" }

  s.source_files = "ios/RNMotionActivity/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
end
