require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  def setup
    @admin = Admin.new(email:"test@test.com", password:"password", password_confirmation:"password")
  end
  
  test "should be valid" do
    assert @admin.valid?
  end
  
  test "email should not be too long" do
    @admin.email = "a" * 218 + "@test.com"
    assert_not @admin.valid?
  end
  
  test "email should be unique" do 
    admin_dup = @admin.dup
    @admin.save
    assert_not admin_dup.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @admin.email = valid_address
      assert @admin.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @admin.email = invalid_address
      assert_not @admin.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "password should be present " do
    @admin.password = @admin.password_confirmation = " " * 6
    assert_not @admin.valid?
  end
  
  test "password should have a minimmum length" do
    @admin.password = @admin.password_confirmation = "a" * 5
    assert_not @admin.valid?
  end
end
