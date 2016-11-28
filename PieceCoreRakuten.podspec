Pod::Spec.new do |s|
    s.name = 'PieceCoreRakuten'
    s.version = '1.0.0'
    s.license = { :type => 'GPL v3', :file => 'LICENSE' }
    s.summary = 'This is piece library for iOS.'
    s.homepage = 'https://jokapi.jp'
    s.author = "jokerpiece"
    s.source = { :git => "https://github.com/jokerpiece/piece-core-rakuten.git", :tag => "#{s.version}"}
    s.platform  = :ios, "9.0"
    s.source_files = "PieceCoreRakuten/**/*.{h,m}"
    s.resources = "PieceCoreRakuten/Resources/**/*.{png, jpg,gif}","PieceCore/**/*.xib"
    s.frameworks = 'IOKit', 'QuartzCore'
    s.dependency 'AFNetworking', '2.6.3'
    s.dependency 'UIActivityIndicator-for-SDWebImage'
    s.dependency 'UIColor+MLPFlatColors'
    s.dependency 'SVProgressHUD', '~> 1.0'
    s.dependency 'Google/Analytics', '~> 1.0.0'
    s.dependency = 'PieceCoreBase', :git => 'https://github.com/jokerpiece/ios_piececore_basekit.git'
end
