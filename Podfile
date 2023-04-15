# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Swift - Netflix' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'LookinServer', :configurations => ['Debug']
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
  pod 'SnapKit', '~> 5.6.0'
  pod 'Colours'
  pod 'SDWebImage'
  pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '3.x'
  pod 'WCDB'
  pod 'AFNetworking', '~> 3.1.0'
  pod 'ViaBus'
  pod 'FCAlertView'
  pod "Aspects"
  pod 'MJRefresh'
  pod 'MMKV'
  # Pods for Swift - Netflix
end

pre_install do |installer|
    puts 'pre_install begin....'
    dir_af = File.join(installer.sandbox.pod_dir('AFNetworking'), 'UIKit+AFNetworking')
    Dir.foreach(dir_af) {|x|
      real_path = File.join(dir_af, x)
      if (!File.directory?(real_path) && File.exists?(real_path))
        if((x.start_with?('UIWebView') || x == 'UIKit+AFNetworking.h'))
          File.delete(real_path)
          puts 'delete:'+ x
        end
      end
    }
    puts 'end pre_install.'
end
