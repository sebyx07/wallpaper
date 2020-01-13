require "open-uri"
require "fileutils"
require "securerandom"

class Manager
  def initialize
    @key = SecureRandom.urlsafe_base64
  end


  def call!
    make_dir
    download_image
    set_wallpaper
    remove_old_images
  end


  private

  def make_dir
    FileUtils.mkdir_p(path("/wallpapers"))
  end

  def download_image
    open("https://cdn.star.nesdis.noaa.gov/GOES16/ABI/FD/GEOCOLOR/1808x1808.jpg") do |image|
      File.open(new_image_path, "wb") do |file|
        file.write(image.read)
      end
    end
  end

  def new_image_path
    @new_image_name ||= path("/wallpapers/wallpaper-#{@key}.jpg")
  end

  def set_wallpaper
    command = "pcmanfm-qt --set-wallpaper='#{new_image_path}' --wallpaper-mode=fit"
    `#{command}`
  end

  def path(file=nil)
    File.expand_path(File.dirname(__FILE__)) + file
  end

  def remove_old_images
    files = Dir.glob(path("/wallpapers/*.jpg"))
    files.each do |f|
      FileUtils.rm_rf(f) unless f == new_image_path
    end
  end
end

Manager.new.call!