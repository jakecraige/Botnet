source "https://github.com/CocoaPods/Specs"

platform :ios, "9.0"
workspace "Botnet"
use_frameworks!

target "Botnet" do
  pod "Reusable"
end

target "ShareExtension"

target "BotnetKit" do
  project "BotnetKit/BotnetKit"
end

target "FirebaseWrapper" do
  project "FirebaseWrapper/FirebaseWrapper"
  pod "Firebase"
  pod "Firebase/Auth"
  pod "Firebase/Crash"
  pod "Firebase/Database"
  pod "FirebaseUI/AuthBase"
end

post_install do |installer|
  copy_acknowledgements_to_settings
end

def copy_acknowledgements_to_settings
  pods_prefix = "Pods-Botnet"
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
