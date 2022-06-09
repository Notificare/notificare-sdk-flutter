Pod::Spec.new do |s|
  s.name             = 'notificare_inbox'
  s.version          = '3.2.0'
  s.summary          = 'Notificare Inbox Flutter Plugin'
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
  s.dependency 'Notificare/NotificareKit', '3.2.0'
  s.dependency 'Notificare/NotificareInboxKit', '3.2.0'
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'
end
