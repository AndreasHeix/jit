require 'Buckets'
require 'Bucket'
require 'Source'

#targetfolder = "?"
#buckets = Buckets.new(targetfolder)
#File.open("log.txt", "w") do |log|
#  log.puts("Output for run with root folder #{targetfolder}")
#end
#  
#buckets.retrieveBuckets.each {|bucket|
#  File.open("log.txt","a") do |log|
#    log.puts(bucket.to_s)  
#  end  
#}

sourcefolder = "?"
source = Source.new(sourcefolder)
files = source.get_all_files
puts "printing all files"
files.each {|file|
  puts(file)
}


