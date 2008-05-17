$LOAD_PATH << '../'

require 'test/unit'
require 'postprojecteuler'

class Test_PostProjectEuler < Test::Unit::TestCase
  def test_login
    pe = PostProjectEuler.new(Pit.get("projecteuler.net", :require => {
         "username" => "username",
         "password" => "password"
         })).login.code
    assert_equal '200', pe
    
  end
end
