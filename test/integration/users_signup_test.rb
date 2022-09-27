require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar"} }
    end
    assert_template 'users/new'
    # test the errors on the page ex 7.3.4 pg 409
    assert_select 'div#error_explanation' #check for id with error explanation
    assert_select 'div.alert-danger'  #check class for field with errors
  end
end
