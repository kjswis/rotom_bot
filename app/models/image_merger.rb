require 'rmagick'
include Magick

def append_image(image1_in, images2_in, image_out)
  i = Magick::ImageList.new
  i = Magick::ImageList.new(image1_in,images2_in)

  u = i.append(true);
  u.write('images/Type Double.png');
end

def crop_image()
  images = ['images/Type Bug.png', 'images/Type Dark.png', 'images/Type Dark - Copy.png']

  img = Magick::Image.read(images[0]).first # path of Orignal image that has to be worked upon
  puts img.inspect

  def try(x,y,width,height)
    images = ['images/Type Bug.png', 'images/Type Dark.png', 'images/Type Dark - Copy.png']

    # converting x,y , width and height to integer values in next four statements
    x= x.to_i
    y= y.to_i
    width= width.to_i
    height= height.to_i

    # Demonstrate the Image#crop method
    @st = images[0] # path of image written after changing size or not changing also
    img = Magick::Image.read(@st)[0]

    # Crop the specified rectangle out of the img.
    chopped = img.crop(x, y, width,height)

    # Go back to the original and highlight the area
    # corresponding to the retained rectangle.
    rect = Magick::Draw.new
    rect.stroke('transparent')
    rect.fill('black')
    rect.fill_opacity(1.0)
    rect.rectangle(x, y, 100+x, 10+y)
    rect.draw(img)

    img.write(images[1]) #path of image written before cropping

    # Create a image to use as a background for
    # the “after” image.
    bg = Magick::Image.new(img.columns, img.rows)

    # Composite the the “after” (chopped) image on the background
    bg = bg.composite(chopped, 38,81, Magick::OverCompositeOp)

    bg.write(images[2]) # path of image written after cropping the desired part
    exit
  end

  try(100, 50, 150, 100)
end