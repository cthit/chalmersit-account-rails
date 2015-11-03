# encoding: utf-8

class ProfileImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  # Resize and convert image
  process :resize_to_fit => [200,200]
  process :white_bg
  process :convert => [:jpg]

  # Override the directory where uploaded files will be stored. ([approot]/public/images/profile_images)
  def store_dir
    "images/profile_images"
  end
  # White list for extensions
  def extension_white_list
    %w(jpg jpeg png bmp gif)
  end

  # Override the filename of the uploaded files:
  def filename
    extension = File.extname(original_filename)
    filename = Digest::SHA1.hexdigest Rails.application.secrets.image_salt + File.basename(original_filename, extension)
    filename + ".jpg"
  end

  private
  def white_bg
    manipulate! do |img|
      img.combine_options do |c|
        c.background "#FFF"
        c.alpha "remove"
      end
      img
    end
  end
end
