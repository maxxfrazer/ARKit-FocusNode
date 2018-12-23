Pod::Spec.new do |s|
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "FocusNode"
  s.version      = "1.1.1"
  s.summary      = "FocusNode creates a node on the ground or wall to show where the centre of the screen hits the active scene."
  s.description  = <<-DESC
  					FocusNode allows users to get a pretty good estimate of a hitTest on vertical or horizontal planes,
            with a node being placed at that location with the correct orientation.
            This class is only a slight alteration of Apple's code found at this location:
            https://developer.apple.com/documentation/arkit/handling_3d_interaction_and_ui_controls_in_augmented_reality
                   DESC
  s.homepage     = "https://github.com/maxxfrazer/ARKit-FocusNode"
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "Max Cobb"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/maxxfrazer/ARKit-FocusNode.git", :tag => "#{s.version}" }
  s.swift_version = '4.2'
  s.ios.deployment_target = '12.0'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "FocusNode/*.swift"
  s.dependency "SmartHitTest"
end
