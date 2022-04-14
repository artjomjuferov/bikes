require 'rails_helper'

RSpec.describe GeneratePdf do
  subject do
    described_class.new(csv_string: csv_string, user: user).call
  end

  let(:csv_string) do
    csv_string = CSV.generate do |csv|
      csv << %w[name surname cc_cert_id cc_name]
      csv << %w[john doe 1d2fa23 central_uk]
    end
  end

  let(:user) { User.new(id: 1)}

  let(:filepath) { Rails.root.join('tmp/certificates/1_1d2fa23_central_uk.pdf')}

  it 'saves pdf and return path_to_pdf' do
    expect(subject).to eq filepath

    expect { Rack::Test::UploadedFile.new(filepath, 'application/pdf') }
      .not_to raise_error
  end
end
