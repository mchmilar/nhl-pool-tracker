require 'rails_helper'

RSpec.describe AdminController, type: :controller do

  describe "GET #panel" do
    it "returns http success" do
      get :panel
      expect(response).to have_http_status(:success)
    end
  end

end
