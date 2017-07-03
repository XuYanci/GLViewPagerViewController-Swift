Pod::Spec.new do |s|
  s.name             = 'GLViewPagerViewController-Swift'
  s.version          = '1.0.0'
  s.summary          = 'ViewPager'
 
  s.description      = <<-DESC
                       GLViewPagerViewController is an common public control, it is usally used in news, here use UIPageViewController and UIScrollView as tab container to build it.
			DESC
 
  s.homepage         = 'https://github.com/XuYanci/GLViewPagerViewController-Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XuYanci' => 'grandy.wind@gmail.com' }
  s.source           = { :git => 'https://github.com/XuYanci/GLViewPagerViewController-Swift.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.source_files = 'GLViewPagerViewController/Classes/**/*'
 
end
