require 'rails_helper'

RSpec.describe 'Licences', type: :request do
  let(:headers) do
    { "ACCEPT" => "application/json" }
  end

  context 'with valid csv uploaded' do
    let(:filepath) { Rails.root.join('spec', 'fixtures', 'valid_licence.csv') }

    it "uploads csv and creates Licence" do
      file = Rack::Test::UploadedFile.new(filepath, 'application/csv')
      params = { file: file }

      post "/api/licences", params: params, headers: headers

      expect(response).to have_http_status(:created)
    end
  end

  context 'with invalid csv uploaded' do
    let(:filepath) { Rails.root.join('spec', 'fixtures', 'invalid_licence.csv') }

    it "does not create licence" do
      file = Rack::Test::UploadedFile.new(filepath, 'application/csv')
      params = { file: file }

      post "/api/licences", params: params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end
