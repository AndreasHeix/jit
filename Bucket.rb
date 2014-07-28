require 'pathname'

class Bucket
  def initialize(rootfolder)
    @rootfolder = rootfolder
#    @suffix = ["jpg", "mp4", "mov"]
    @youngestFileMap = Hash.new
#    @androidPattern = /\d{8}/
#    @androidPrefix = "android"
  end

    ANDROID_PREFIX_PATTERN = /\d{8}/
    ANDROID_PREFIX_REPLACEMENT = "android" 
  
  def retrieve_allFiles
    retrieve_validFilesRecursive(@rootfolder)
  end

  def get_year_month
    dates_as_string = @rootfolder.basename.to_s.split("_")
    dates_as_integer =dates_as_string[0].to_i, dates_as_string[1].to_i
  end

  def add_file(file)
    puts("will copy file #{file} to folder #{@rootfolder} if it is not too old...")
    prefix = calc_prefix(file)
    currentYoungestDate = @youngestFileMap[prefix]
    if (currentYoungestDate)
      if (currentYoungestDate < file.mtime)
        puts("will not copy file #{file} to folder #{@rootfolder} as it is too old - must be younger than #{currentYoungestDate}")
        return
      end
    end
    FileUtils.cp(file, @rootfolder, options = {:preserve=>true})
    @youngestFileMap[prefix] = file.mtime
    puts (self.to_s)
  end

  def retrieve_validFilesRecursive(folder)
    validFiles = []
    children = Pathname.new(folder).children.select{|e|
      if (e.directory?)
        validFiles << retrieve_validFilesRecursive(e)
      else
        update_youngest_file(e)
        validFiles << e
      end
    }
    validFiles
  end

  def update_youngest_file(file)
    filename_prefix = calc_prefix(file)
    youngestDate = @youngestFileMap[filename_prefix]
    if (youngestDate.nil?)
      @youngestFileMap[filename_prefix] = File.mtime(file)
    else
      if (youngestDate < File.mtime(file))
        @youngestFileMap[filename_prefix] = File.mtime(file)
      end
    end
  end

  def calc_prefix(file)
    filename = file.basename.to_s
    filename_prefix = nil
    if (!filename.index("_").nil?)
      filename_prefix = filename.split("_")[0]
      if (filename_prefix =~ ANDROID_PREFIX_PATTERN)
        filename_prefix = ANDROID_PREFIX_REPLACEMENT
      end 
    end
    filename_prefix
  end

  def to_s
    retrieve_allFiles()
    "Rootfolder is #{@rootfolder} with youngest dates: #{@youngestFileMap}"
  end

end

