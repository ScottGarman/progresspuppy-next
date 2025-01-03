require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Bubba",
                     last_name: "Jones",
                     email_address: "bubbajones@example.com",
                     password: "foobarbaz12345",
                     password_confirmation: "foobarbaz12345")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first_name should be present and not empty" do
    @user.first_name = "  "
    assert @user.invalid?
    assert @user.errors[:first_name].any?
  end

  test "first name should not be too long" do
    # 50-char first_name
    @user.first_name = "a" * 50
    assert @user.valid?

    # 51-char first_name
    @user.first_name = "a" * 51
    assert @user.invalid?
    assert @user.errors[:first_name].any?
  end

  test "last_name should be present and not empty" do
    @user.last_name = "  "
    assert @user.invalid?
    assert @user.errors[:last_name].any?
  end

  test "last name should not be too long" do
    # 50-char last_name
    @user.last_name = "a" * 50
    assert @user.valid?

    # 51-char last_name
    @user.last_name = "a" * 51
    assert @user.invalid?
    assert @user.errors[:last_name].any?
  end

  test "email address should be present and not empty" do
    @user.email_address = "  "
    assert @user.invalid?
    assert @user.errors[:email_address].any?
  end

  test "email address should not be too short" do
    # 3-char email address
    @user.email_address = "a@b"
    assert @user.invalid?
    assert @user.errors[:email_address].any?

    # 4-char email address
    @user.email_address = "a@b.co"
    assert @user.valid?
  end

  test "email address should not be too long" do
    @user.email_address = "a" * 250 + "@example.com"
    assert @user.invalid?
    assert @user.errors[:email_address].any?

    # 80-char email address
    @user.email_address = "a" * 75 + "@b.co"
    assert @user.valid?
  end

  test "email address validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email_address = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email address validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email_address = invalid_address
      assert @user.invalid?, "#{invalid_address.inspect} should be invalid"
      assert @user.errors[:email_address].any?
    end
  end

  test "email addresses should be case-insensitive unique" do
    duplicate_user = @user.dup
    duplicate_user.email_address = @user.email_address.upcase
    @user.save
    assert duplicate_user.invalid?
    assert duplicate_user.errors[:email_address].any?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email_address = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email_address
  end

  test "password should be present and not empty" do
    @user.password = @user.password_confirmation = " " * 14
    assert @user.invalid?
    assert @user.errors[:password].any?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 13
    assert @user.invalid?
    assert @user.errors[:password].any?

    @user.password = @user.password_confirmation = "a" * 14
    assert @user.valid?
  end

  test "each new User should have a default Settings object" do
    @user.save!
    assert_not_nil @user.setting
  end

  test "each new User should have an Uncategorized TaskCategory object" do
    @user.save!
    assert_not_empty @user.task_categories
    assert_equal 1, @user.task_categories.size
    assert_equal "Uncategorized", @user.task_categories.first.name
  end

  test "ensure associated model objects get destroyed when a user is" \
       " destroyed" do
    @user.save!
    assert_equal 0, @user.quotes.count
    assert_equal 0, @user.tasks.count

    quote = Quote.new(quotation: "Sample Quotation", source: "Source")
    @user.quotes << quote
    assert_equal 1, @user.quotes.count

    task = Task.new(summary: "My first task",
                    task_category_id: @user.task_categories.first.id)
    @user.tasks << task
    assert_equal 1, @user.tasks.count

    setting_id = @user.setting.id
    assert_not_nil setting_id
    tc_id = @user.task_categories.first.id
    assert_not_nil tc_id
    task_id = @user.tasks.first.id
    assert_not_nil task_id
    quote_id = @user.quotes.first.id
    assert_not_nil quote_id

    @user.destroy!
    assert_nil Setting.find_by_id(setting_id)
    assert_nil TaskCategory.find_by_id(tc_id)
    assert_nil Task.find_by_id(task_id)
    assert_nil Quote.find_by_id(quote_id)
  end
end
