require "test_helper"

class SettingTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Bubba",
                     last_name: "Jones",
                     email_address: "bubbajones@example.com",
                     password: "foobarbaz12345",
                     password_confirmation: "foobarbaz12345")
    @user.save!

    @setting = Setting.new
  end

  test "setting must be associated with a User" do
    assert @setting.invalid?
    assert @setting.errors[:user_id].any?

    # The User model generates a default setting when it was created
    assert @user.setting.valid?

    @user.setting = @setting
    assert @setting.valid?
  end
end
