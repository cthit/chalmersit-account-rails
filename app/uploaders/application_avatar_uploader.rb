# encoding: utf-8

class ApplicationAvatarUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "images/application_images"
  end
  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files: 'App_Name' + '.jpg/.png/etc..'
  def filename
    puts model.name
    puts original_filename
    model.name + File.extname(original_filename)
  end
end
