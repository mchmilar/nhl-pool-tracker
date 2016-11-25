require 'rails_helper'
require 'spec_helper'

describe User, type: :model do
  it "has a valid factor" do
    user = FactoryGirl::build(:user)
    expect(user).to be_valid
  end
end

describe User do
  
  before do
    @user = FactoryGirl::build(:user)
  end
  
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_length_of(:password) }
  it { is_expected.to validate_length_of(:email) }
  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank}
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  
  describe "when password is not present" do 
    it "should not be valid" do
      @user.password = " "
      should_not be_valid
    end
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = @user.password + "2" }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "should find user" do
     it { expect(found_user).to_not be_nil }
    end
    
    describe "with valid password" do
      it { expect(found_user.authenticate(@user.password)).to eq @user }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate(@user.password + "a") }
      it { expect(user_for_invalid_password).to be false }
      specify { expect(user_for_invalid_password).to be false }
    end
  end
  
end