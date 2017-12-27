@version = "1.2"

Pod::Spec.new do |s|
s.name = "XMenuView"
s.version = @version
s.summary = "自定义分页目录切换"
s.description = "可复用性强，可定制你想要的效果 segmentControl 、 menu"
s.homepage = "https://github.com/futrue/XMenuView"
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.author = { "SongGuoxing" => "1146776306@qq.com" }
s.ios.deployment_target = '8.0'
s.source = { :git => "https://github.com/futrue/XMenuView.git", :tag => "v#{s.version}" }
s.source_files = 'XMenuView/XSegmentVC/*.{h,m}'
s.requires_arc = true
s.framework = "UIKit"
end
