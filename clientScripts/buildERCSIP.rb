require 'pathname'
require 'digest/md5'
require 'open-uri'  # For retrieving dublincore.xml

def error(text)
  puts text
  exit(1)
end

# If the directory does not exist, create it; if it does, leave it;
# if it is blocked by a file, exit with an error.
def create_dir(root, dir)
  if !(root + dir).exist?
    Dir.mkdir(root + dir)
  elsif(root + dir).file?
    error("ERROR: #{dir} should not be a file")
  end
end

puts '***** Build ERC SIP'

# Get the target directory
target = Pathname.new(ARGV[0])
puts "Target directory: #{target}"

puts "Verifying existing structure..."
# Verify that the target contains a "metadata" directory with an erc.txt file. 
if !(target + "metadata/erc.txt").file?
  error("ERROR: metadata/erc.txt file not found")
end

# Verify that the target contains an "objects" folder with at least one file 
# (and possibly subdirs as well).
if !(target + "objects").directory?
  error("ERROR: objects directory not found")   
end
found_file = false
(target + "objects").find() do |entry|
  if entry.file?
    found_file = true
    break
  end
end
if found_file == false
  error("ERROR: No files in objects directory")
end

puts "Creating directories..."
# Create directories "logs", "logs/fileMeta", and 
# "metadata/submissionDocumentation" if they don't already exist.
create_dir(target, "logs")
create_dir(target, "logs/fileMeta")
create_dir(target, "metadata/submissionDocumentation")

puts "Generating MD5 checksums..."
# Generate file "metadata/checksum.md5".
if (target + "metadata/checksum.md5").exist?
  error("ERROR: metadata/checksum.md5 already exists")
else
  new_file = File.open(target + "metadata/checksum.md5", "w")
  Dir.chdir(target + "objects/") do
    # Changing the working dir to "objects" makes sure paths are returned in
    # the format we want (e.g. "./file.txt", not "objects/file.txt").
    Find.find("./") do |entry|
      if FileTest.file?(entry)
        digest = Digest::MD5.hexdigest(IO.read(entry))
        new_file.puts digest + "  " + entry
      end
    end
  end
  new_file.close
end

puts "Importing Dublin Core metadata..."
# Download and insert file "metadata/dublincore.xml".
File.open(target + 'metadata/dublincore.xml', 'w') do |new_file|
  open('http://scdp.uky.edu/mps/presence/samples/dublincore.xml') do |web_file|
    new_file.write(web_file.read)
  end
end

exit(0)
