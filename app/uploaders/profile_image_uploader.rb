# encoding: utf-8

class ProfileImageUploader < CarrierWave::Uploader::Base
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
    extension = File.extname(original_filename)
    filename = Digest::SHA1.hexdigest ('kerplol123' + File.basename(original_filename, extension))
    filename += extension
    filename
  end
end
