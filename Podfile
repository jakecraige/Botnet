source "https://github.com/CocoaPods/Specs"

platform :ios, "9.0"

# Uncomment this line if you use Swift
use_frameworks!

target_name = "Botnet"

target "Botnet" do
  # Application Pods
end

abstract_target :unit_tests do
  target "UnitTests"
end

post_install do | installer |
  require "fileutils"

  pods_prefix = "Pods-#{target_name}"
  pods_acknowledgements_path =
    "Pods/Target Support Files/#{pods_prefix}/#{pods_prefix}-Acknowledgements.plist"
  settings_bundle_path = Dir.glob("**/*Settings.bundle*").first

  if File.file?(pods_acknowledgements_path)
    puts "Copying acknowledgements to Settings.bundle"
    FileUtils.cp_r(
      pods_acknowledgements_path,
      "#{settings_bundle_path}/Acknowledgements.plist",
      remove_destination: true
    )
  end
end

