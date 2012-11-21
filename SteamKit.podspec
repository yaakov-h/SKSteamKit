Pod::Spec.new do |s|
  s.name         = "SKSteamKit"
  s.version      = "0.1.0"
  s.summary      = "SteamKit port for Objective-C"
  s.description  = <<-DESC
	Objective-C library for connecting to the Steam network. Based on SteamKit/SteamRE by OpenSteamWorks.
                    DESC
  s.homepage     = "https://github.com/yaakov-h/SKSteamKit"

  s.author       = 'Yaakov'
  s.source       = { :git => "https://github.com/yaakov-h/SKSteamKit.git" }

  s.platform     = :ios, '6.0'
  s.public_header_files = 'SteamKit/**/{SK,SteamKit}*.h'
  s.framework  = 'Foundation', 'UIKit', 'CoreGraphics'
  s.requires_arc = true
  
 s.subspec 'arc' do |a|
  a.source_files = 'SteamKit/Messages/SteamLanguage/**/*.{h,m}', 'SteamKit/Messages/_*.{h,m}', 'SteamKit/{Crypto,Networking,Steam3,Util}/**/*.{h,m}'
  a.requires_arc	= true
 end
 
 s.subspec 'nonarc' do |na|
  na.source_files = 'SteamKit/Messages/**/*.pb.{h,m}'
  na.requires_arc	= false
 end

 s.dependency 'ProtocolBuffers',	:podspec => 'podspecs/ProtocolBuffers.podspec'
 s.dependency 'CocoaAsyncSocket',	'~> 0.0.1'
 s.dependency 'CRBoilerplate',	:podspec => 'podspecs/CRBoilerplate.podspec'
 s.dependency 'OpenSSL',          :podspec => 'podspecs/OpenSSL.podspec'
 s.dependency 'zipzap',           :podspec => 'podspecs/zipzap.podspec'
end
