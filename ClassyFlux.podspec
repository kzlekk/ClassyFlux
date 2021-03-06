Pod::Spec.new do |s|
  s.name             = 'ClassyFlux'
  s.version          = '2.0.1'
  s.summary          = 'Flux implementation in Swift'
  s.homepage         = 'https://github.com/kzlekk/ClassyFlux'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Natan Zalkin' => 'natan.zalkin@me.com' }
  s.source           = { :git => 'https://github.com/kzlekk/ClassyFlux.git', :tag => "#{s.version}" }
  s.module_name      = 'ClassyFlux'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.14'
  s.watchos.deployment_target = '5.0'
  s.tvos.deployment_target = '12.0'

  s.dependency 'ResolvingContainer'

  s.source_files = 'ClassyFlux/*.swift'

end
