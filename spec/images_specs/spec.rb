# bin/bundle exec ruby spec/images_spec/spec.rb
require 'the_image'
_root_ = File.expand_path('../',  __FILE__)

class Tool; include TheImage; end
tool = Tool.new

src  = "#{ _root_ }/169x150.png"
dest = "#{ _root_ }/test_1.png"

tool.manipulate({ src: src, dest: dest }) do |image, opts|
  puts [ image[:width], image[:height] ].join 'x'
  image = auto_orient image
  image = strip image
  image = to_rect image, 270, 210
end
