require 'pathname'

class Source
  def initialize(rootfolder)
    @rootfolder = rootfolder

  end

  def copy(target)
    files = get_all_files
    files.each {|file|
      targetbucket = target.get_fitting_bucket(file)
      if (targetbucket)
        puts "Target for #{file} is bucket #{targetbucket}"
        targetbucket.add_file(file)
      else
        puts "Target for #{file} is not yet existing"
      end

    }

  end

  def get_all_files
    files = []
    get_all_files_recursive(@rootfolder,files)
    files
  end

  def get_all_files_recursive(rootfolder, files)
    puts("Iterating through #{rootfolder}")
    children = Pathname.new(rootfolder).children.select{|e|
      if (e.directory?)
        puts("#{e} is a directory")
        get_all_files_recursive(e, files)
      else
        puts("adding #{e} to the set")
        files << e
      end
    }
  end

end