require 'rails_helper'

RSpec.describe "Errors", type: :request do
  describe "GET /page_not_found" do
    it "returns http success" do
      get "/errors/page_not_found"
      expect(response).to have_http_status(:success)
    end
  end

end
