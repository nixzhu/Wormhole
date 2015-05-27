Pod::Spec.new do |s|

  s.name        = "Wormhole"
  s.version     = "1.0"
  s.summary     = "A more elegant way for message passing between iOS apps and extensions."

  s.description = <<-DESC
                   Wormhole is not just a Swift port of MMWormhole but with better API and use logic.
                   You can remove any a listener from it separately.
                   DESC

  s.homepage    = "https://github.com/nixzhu/Wormhole"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "nixzhu" => "zhuhongxu@gmail.com" }
  s.social_media_url  = "https://twitter.com/nixzhu"

  s.ios.deployment_target   = "8.0"
  # s.osx.deployment_target = "10.7"

  s.source          = { :git => "https://github.com/nixzhu/Wormhole.git", :tag => s.version }
  s.source_files    = "Wormhole/*.swift"
  s.requires_arc    = true

end