$:.unshift(File.expand_path('../../lib', __FILE__))
require 'peddler'
require 'minitest/autorun'
require 'minitest/pride'
begin
  require 'pry'
rescue LoadError
end

MWS_KEYS = YAML.load_file(File.expand_path('../amazon.yml', __FILE__))
