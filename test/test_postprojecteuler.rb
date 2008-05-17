$LOAD_PATH << '../lib'

require 'test/unit'
require 'postprojecteuler'

class Test_PostProjectEuler < Test::Unit::TestCase
  def setup
    @pe = PostProjectEuler.new(Pit.get("projecteuler.net", :require => {
         "username" => "username",
         "password" => "password"
         }))
    @pe.login
  end

  def test_login
    assert_equal '200', @pe.login.code
  end

  def test_post
    assert_equal '200', @pe.post(15, 3).code
  end
end
