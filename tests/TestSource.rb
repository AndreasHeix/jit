require 'minitest/autorun'
require 'FileUtils'
require '../Source.rb'
require '../Buckets'

class TestSource < MiniTest::Unit::TestCase

  ROOT_FOLDER_PATH = File.join(Dir.pwd, "testfolderRoot")

  def setup
    puts ROOT_FOLDER_PATH
    if (Dir.exists?(ROOT_FOLDER_PATH))
      puts("Deleting #{ROOT_FOLDER_PATH} leftover from previous test run...")
      FileUtils.rm_rf(ROOT_FOLDER_PATH)
    end
    filehash = Hash.new()
    filehash["prefix_file1_1990_feb_24.txt"] = Time.utc(1990, 02, 24, 12, 0, 0)
    filehash["subfolder/prefix_file2_1991_mar_24.txt"] = Time.utc(1991, 03, 24, 12, 0, 0)
    setup_mock_file_system_source(ROOT_FOLDER_PATH, filehash)
    setup_mock_file_system_target(ROOT_FOLDER_PATH, filehash)
  end
  
  def setup_mock_file_system_source(rootfolder, filehash)
    rootfolder_path = File.join(rootfolder, "source")
    puts "source folder is #{rootfolder_path}"
    testfolderRoot = FileUtils.mkdir_p(rootfolder_path)

    filehash.each() {|fileEntry|
      file_path = File.join(rootfolder_path, fileEntry[0])
      FileUtils.mkdir_p File.dirname(file_path)
      File.write(file_path, "")
      File.utime(fileEntry[1], fileEntry[1], file_path)
    }
  end

  def setup_mock_file_system_target(rootfolder, filehash)
    rootfolder_path = File.join(rootfolder, "target/1990")
    puts "target folder is #{rootfolder_path}"
    testfolderRoot = FileUtils.mkdir_p(rootfolder_path)
    months = ["1990_03", "1990_02"]
    months.each { |month|
      testfolderRoot = FileUtils.mkdir_p(File.join(rootfolder_path, month))
    }

  end
  
  def test_default_is_zero
    source = Source.new(File.join(ROOT_FOLDER_PATH, "source"))
    buckets = Buckets.new(File.join(ROOT_FOLDER_PATH, "target"))
    source.copy(buckets)
  end
end



