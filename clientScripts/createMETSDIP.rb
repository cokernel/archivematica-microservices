# This program will create a METS DIP from an existing AIP by removing the 
# data/objects directory.

require 'rubygems'
require 'bagit'
require 'pathname'
require 'fileutils'
require 'validatable'

puts "***** Create METS DIP"

# Get the target bag
target = Pathname.new(ARGV[0])
puts "Target bag: #{target}"
@bag = BagIt::Bag.new target

# Delete the objects directory and its contents from the bag
puts "Deleting files in objects directory..."
@bag.paths.each do |path|
  if path.start_with? 'objects'
    printf("  Deleting %s...\n", path)
    @bag.remove_file(path)
  end
end
puts "Cleaning up empty directories..."
@bag.gc!  # Garbage collection

# Update the manifest
puts "Updating the manifest..."
@bag.manifest!

# Validate the bag and return the appropriate exit status
exit_code = @bag.valid?
puts "Done! exit code = " + exit_code.to_s()
exit(exit_code)
