# encoding: utf-8

class ProfileImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  storage :file
  # Override the directory where uploaded files will be stored.
  def store_dir
    "images/profile_images"
  end
   def extension_white_list
     %w(jpg jpeg)
   end

  # Override the filename of the uploaded files:
  def filename
    puts original_filename + "\n\n\n"
    filename = Digest::SHA1.hexdigest ('kerplol123' + original_filename)
    filename += ".jpg"
    puts filename + "\n\n\n\n\n"
    filename
  end
end
