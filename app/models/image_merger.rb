require 'rmagick'
include Magick

def append_image(image1_in, images2_in, image_out)
  i = Magick::ImageList.new(image1_in,images2_in)

  u = i.append(true);
  u.write('images/Type Double.png');
end

def merge_image(image_array, image_out, output_width, output_height, xaxis, yaxis, image_width, image_height)
  i = Magick::ImageList.new(*image_array)

  binding.pry
  v = Magick::ImageList.new
  arr = Array.new(0)

  i.each.with_index do |item, index|
    if image_width[index] && image_height[index]
      i[index] = item.resize(image_width[index], image_height[index])
    end

    if xaxis[index] && yaxis[index]
      v.new_image(output_width, output_height) { self.background_color = "transparent" }

      i[index] = v.composite(i[index], xaxis[index], yaxis[index], OverCompositeOp).write(image_out + index.to_s + ".png");  
    else
      i[index].write(image_out + index.to_s + ".png");  
    end

    arr << image_out + index.to_s + ".png"
  end

  i = Magick::ImageList.new(*arr)
  i = i.flatten_images();
  i.write(image_out + ".png")
end

def merge_image_slow(image_array, image_out, output_width, output_height, xaxis = nil, yaxis = nil, image_width = nil, image_height = nil)
  i = Magick::ImageList.new(*image_array)
  u = Magick::ImageList.new(*image_out)
  v = Magick::ImageList.new

  if(i.count > 1)
    if output_width && output_height
      i.each.with_index do |item, index|

        if !(xaxis && yaxis)
          i[index] = item.resize(output_width, output_height)
          i[0] = i[0].composite(i[index], output_width, output_height, OverCompositeOp)
        end
        
        if index == 0
          u = i[0].write(*image_out);
        else
          if xaxis && yaxis          
            v.new_image(output_width, output_height) { self.background_color = "transparent" }

            if image_width && image_height
              i[index] = i[index].resize(image_width, image_height)
            end
            v = v.composite(i[index], xaxis, yaxis, OverCompositeOp).write(*image_out);
            u = u.composite(v, xaxis, yaxis, OverCompositeOp).write(*image_out);
          else
            u = u.composite(i[index], CenterGravity, OverCompositeOp).write(*image_out)
          end
        end
      end
    else
      #No output_width, output_height
    end
  else
    i[0] = i[0].resize(image_width, image_height)

    v.new_image(output_width, output_height) { self.background_color = "transparent" }
    v = v.composite(i[0], xaxis, yaxis, OverCompositeOp).write(*image_out);
  end
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