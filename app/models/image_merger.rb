require 'rmagick'
include Magick

def append_image(image1_in, images2_in, image_out)
  i = Magick::ImageList.new(image1_in,images2_in)

  u = i.append(true);
  u.write('images/Type Double.png');
end

def merge_image(image_array, image_out, output_width, output_height, xaxis, yaxis, image_width, image_height)
  i = Magick::ImageList.new(*image_array)

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