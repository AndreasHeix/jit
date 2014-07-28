require_relative 'Bucket.rb'

class Buckets

  def initialize(rootfolder)
    @rootfolder = rootfolder
#    @suffix = ["jpg", "mp4", "mov"]
    @youngestFileMap = Hash.new
    @validBucketPattern = /\d{4}_\d{2}/
    @retrieved_buckets = false
  end
  
  def retrieveBuckets
    @buckets = []
    if (@retrieved_buckets == false)
      @buckets = retrieveBucketsRecursive(@rootfolder, @buckets)
    end
    @buckets
  end

  def get_fitting_bucket(source_file)
    retrieveBuckets
    year = source_file.atime.year
    month = source_file.atime.month
    puts "file's date is #{year} and #{month}"
    @buckets.each {|bucket|
      yearmonth = bucket.get_year_month
      puts "bucket's date is #{yearmonth[0]} and #{yearmonth[1]}"
      puts "bucket's date is #{yearmonth[0].class.to_s} and #{yearmonth[1].class.to_s}"
      if (year.equal?(yearmonth[0]))
        puts "found matching year"
        if (month.equal?(yearmonth[1]))
          puts "found matching month"
          return bucket
        end
      end
    }
    puts "No bucket existing yet - creating it..."
    path_of_new_bucket = File.join(@rootfolder, year.to_s, year.to_s + "_" + month.to_s)
    FileUtils.mkdir_p(path_of_new_bucket)
    new_bucket = Bucket.new(path_of_new_bucket)
    @buckets <<  new_bucket
    new_bucket
  end
  
  def retrieveBucketsRecursive(folder, buckets)
      children = Pathname.new(folder).children.select{|e| e.directory?}.map
      children.each do |child| 
        directoryName = child.basename.to_s
        if (directoryName =~ @validBucketPattern)
          buckets << Bucket.new(child)
        else 
          retrieveBucketsRecursive(child, buckets)  
        end
        
      end
      buckets
    end
    
    
  
  def to_s
    "rootfolder is #{@rootfolder}"
  end

end