Pod::Spec.new do |s|
  s.name             = "ChineseSubdivisionsPicker"
  s.version          = "0.4.0"
  s.summary          = "ChineseSubdivisionsPicker is a simple Chinese Subdivisions picker inherited from UIPickerView and written in Swift."
  s.description      = <<-DESC
                         ChineseSubdivisionsPicker is a simple Chinese Subdivisions picker inherited from UIPickerView and written in Swift.

                         You can let user pick province, city and district data from it.

                         Campatible from iOS7 to iOS9.
                       DESC
  s.homepage         = "https://github.com/huajiahen/ChineseSubdivisionsPicker"
  s.screenshots      = "https://raw.githubusercontent.com/huajiahen/ChineseSubdivisionsPicker/master/ScreenShot.png"
  s.license          = 'MIT'
  s.author           = { "huajiahen" => "forgottoon@gmail.com" }
  s.source           = { :git => "https://github.com/huajiahen/ChineseSubdivisionsPicker.git", :tag => "#{s.version}" }

  s.ios.deployment_target = "8.0"
  s.requires_arc = true

  s.source_files = 'ChineseSubdivisionsPicker/*'
end
