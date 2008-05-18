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

  def test_logout
    assert_equal false, @pe.logout
  end

  def test_post
    @pe.logout
    assert_raises (NotLoggedinError) { @pe.post(1, 1) }
    @pe.login
    assert_raises (PostProjectEulerError) { @pe.post(1, 1)}
    assert_equal '200', @pe.post(14, 15).code
  end
end
