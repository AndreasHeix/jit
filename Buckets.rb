require 'Bucket'

class Buckets

  def initialize(rootfolder)
    @rootfolder = rootfolder
#    @suffix = ["jpg", "mp4", "mov"]
    @youngestFileMap = Hash.new
    @validBucketPattern = /\d{4}_\d{2}/  
  end
  
  def retrieveBuckets
    buckets = []
    retrieveBucketsRecursive(@rootfolder, buckets)
    buckets
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