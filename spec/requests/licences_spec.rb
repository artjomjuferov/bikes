require 'rails_helper'

RSpec.describe 'Licences', type: :request do
  let(:user) { User.create! email: 'john@doe.com' }

  describe 'POST #create' do
    let(:file) { Rack::Test::UploadedFile.new(filepath, 'application/csv') }

    let(:params) do
      { file: file, user_id: Base64.encode64(user.id.to_s) }
    end

    context 'with valid csv uploaded' do
      let(:filepath) { Rails.root.join('spec', 'fixtures', 'valid_licence.csv') }

      it "uploads csv and creates Licence" do
        expect {
          post "/api/licences", params: params, headers: headers
        }.to change(UserMailer.deliveries, :count).by(1)
        .and change(Licence, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid csv uploaded' do
      let(:filepath) { Rails.root.join('spec', 'fixtures', 'invalid_licence.csv') }

      it "does not create licence" do
        expect {
          post "/api/licences", params: params, headers: headers
        }.to change { UserMailer.deliveries.count }.by(0)
        .and change(Licence, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when not authorized' do
      let(:params) do
        { user_id: 0 }
      end

      it "returns unauthorized error" do
        expect do
          post "/api/licences", params: params, headers: headers
        end.to change { UserMailer.deliveries.count }.by(0)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #download' do
    let(:params) do
      { user_id: Base64.encode64(user.id.to_s) }
    end

    context 'when user does not have a licence' do

      it "returns unauthorized error" do
        get "/api/licences", params: params, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
