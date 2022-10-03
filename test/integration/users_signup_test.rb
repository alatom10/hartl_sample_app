require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup 
    ActionMailer::Base.deliveries.clear #setup the mailer pg 661, because deliveries is global we need to reset it here as part of the setup
  end

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
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User", 
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" }  }
    end
    follow_redirect!
    # assert_template 'users/show'
    assert_not flash.empty?
    # assert is_logged_in?
  end

  test "valid signup information with account activation" do get signup_path
    assert_difference 'User.count', 1 do
    post users_path, params: { user: { name: "Example User", email: "user@example.com",
                                           password:              "password",
                                           password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size #checks that 1 email message was delivered/sent
    user = assigns(:user) #assigns lets us access instance variables in the corresponding action. pg 662
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email) 
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong') 
    assert_not is_logged_in?
        # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email) 
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
