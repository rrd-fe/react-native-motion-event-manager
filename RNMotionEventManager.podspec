require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|

  s.name           = 'RNMotionEventManager'
  s.version        = package['version']
  s.summary        = package['description']
  s.author         = package['author']
  s.license        = package['license']
  s.homepage       = package['homepage']
  s.source         = { :git => 'https://github.com/rrd-fe/react-native-motion-event-manager.git', :tag => "#{s.version}" }
  s.platform       = :ios, '8.0'

  s.source_files  = 'ios/**/*.{h,m,c,mm,md}'
  s.public_header_files = 'ios/*.h'

  s.dependency 'React'

end
