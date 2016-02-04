Pod::Spec.new do |s|
  s.name         = "RZTransitions"
  s.version      = "1.2.1"
  s.summary      = "RZTransitions is a library to help make iOS7 custom View Controller transitions slick and simple."

  s.description  = <<-DESC
                   RZTransitions is a library to help make iOS7 custom View Controller transitions slick and simple.
                   Features Include:
                   * A comprehensive library of animation controllers
                   * A comprehensive library of interaction controllers
                   * Mix and match any animation controller with any interaction controller
                   * A shared instance manager that helps wrap the iOS7 custom transition protocol to expose a friendlier API
                   DESC

  s.homepage     = "https://github.com/Raizlabs/RZTransitions"
  s.screenshots  = "http://raw.github.com/Raizlabs/RZTransitions/master/Web/RZTransitionsDemo.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Stephen Barnes" => "stephen.barnes@raizlabs.com" }
  s.social_media_url   = "http://twitter.com/raizlabs"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Raizlabs/RZTransitions.git", :tag => "1.2.1" }
  s.source_files  = "RZTransitions/**/*.{h,m,swift}"
  s.frameworks    = "CoreGraphics", "UIKit", "Foundation"
  s.requires_arc  = true

end
