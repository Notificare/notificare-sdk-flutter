require 'yaml'

pubspec = YAML.load(File.read(File.join(__dir__, "..", "pubspec.yaml")))
notificare_version = '3.5.4'

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = pubspec['version']
  s.summary          = 'Notificare In-App Messaging Flutter Plugin'
  s.description      = <<-DESC
The Notificare Flutter Plugin implements the power of smart notifications, location services, contextual marketing and powerful loyalty solutions provided by the Notificare platform in Flutter applications.

For documentation please refer to: http://docs.notifica.re
For support please use: http://support.notifica.re
                       DESC
  s.homepage         = 'https://notificare.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Notificare' => 'info@notificare.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Notificare/NotificareKit', notificare_version
  s.dependency 'Notificare/NotificareInAppMessagingKit', notificare_version
  s.platform = :ios, '11.0'
  s.swift_version = '5.0'
end
