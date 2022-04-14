require 'rails_helper'

RSpec.describe 'Licences', type: :request do
  let(:headers) do
    { "ACCEPT" => "application/json" }
  end

  let(:user) { User.create! }
  let(:file) { Rack::Test::UploadedFile.new(filepath, 'application/csv') }

  let(:params) do
    { file: file, user_id: Base64.encode64(user.id.to_s) }
  end

  context 'with valid csv uploaded' do
    let(:filepath) { Rails.root.join('spec', 'fixtures', 'valid_licence.csv') }

    it "uploads csv and creates Licence" do
      post "/api/licences", params: params, headers: headers

      expect(response).to have_http_status(:created)
    end
  end

  context 'with invalid csv uploaded' do
    let(:filepath) { Rails.root.join('spec', 'fixtures', 'invalid_licence.csv') }

    it "does not create licence" do
      post "/api/licences", params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when not authorized' do
    let(:params) do
      { user_id: 0 }
    end

    it "returns unauthorized error" do
      post "/api/licences", params: params, headers: headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
