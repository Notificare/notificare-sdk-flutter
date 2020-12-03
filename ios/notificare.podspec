#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'notificare'
  s.version          = '3.0.0'
  s.summary          = 'Notificare Flutter Plugin'
  s.description      = <<-DESC
Notificare Flutter Plugin implements the power of smart notifications, location services, contextual marketing and powerful loyalty solutions provided by the Notificare platform in Flutter applications.\n\nFor documentation please refer to: http://docs.notifica.re\n\nFor support please use: http://support.notifica.re
                       DESC
  s.homepage         = 'https://notificare.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Notificare' => 'info@notificare.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Notificare/NotificareSDK', '>= 3.0.0-alpha.1'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
