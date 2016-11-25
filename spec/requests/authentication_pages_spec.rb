require 'spec_helper'
require 'rails_helper'

describe "Authentication" do
  subject { page }

  describe "login" do
    before { visit login_path }

    describe "with invalid information" do
    	before { click_button "Log in" }

    	it { should have_title('Log in') }
    	it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Players" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
		  let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Log in"
      end

      it { should have_link('Logout', href: logout_path) }
      it { should_not have_link('Log in', href: login_path) }

      describe "followed by signout" do
        before { click_link "Logout" }
        it { should have_link "Login" }
      end
    end
  end
end
