require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "with valid attributes" do
      it "create new user" do
        post :create, user: attributes_for(:user)
        expect(User.count).to eq(1)
      end
    end
    
    context "with invalid attributes" do
      it "does not create a new contact" do
        post :create, user: attributes_for(:invalid_user)
        expect(User.count).to eq(0)
      end
    end
  end
  
end
