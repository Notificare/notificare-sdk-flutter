#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint notificare_inbox.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'notificare_inbox'
  s.version          = '3.0.0-alpha.1'
  s.summary          = 'Notificare Inbox Flutter Plugin'
  s.description      = <<-DESC
Notificare Inbox Flutter Plugin
                       DESC
  s.homepage         = 'https://notificare.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Notificare' => 'info@notificare.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Notificare/NotificareInboxKit', '3.0.0-alpha.1'
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'
end
