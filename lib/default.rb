# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require "digest/md5"

# Ensure that my custom libs are loaded first.
$LOAD_PATH.insert 0, File.expand_path(File.dirname(__FILE__))
require "my_lib"
require "my_filters"
$LOAD_PATH.delete_at 0
