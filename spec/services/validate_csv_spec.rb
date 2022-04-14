require 'rails_helper'

RSpec.describe ValidateCsv do
  subject do
    described_class.new(csv_string: csv_string).call
  end

  context 'with missing name' do
    let(:csv_string) do
      csv_string = CSV.generate do |csv|
        csv << %w[surname cc_cert_id cc_name]
        csv << %w[doe 1d2fa23 central_uk]
      end
    end

    it { is_expected.to be_falsey }
  end

  context 'with missing surname' do
    let(:csv_string) do
      csv_string = CSV.generate do |csv|
        csv << %w[name cc_cert_id cc_name]
        csv << %w[john 1d2fa23 central_uk]
      end
    end

    it { is_expected.to be_falsey }
  end

  context 'with missing cc_cert_id' do
    let(:csv_string) do
      csv_string = CSV.generate do |csv|
        csv << %w[name surname cc_name]
        csv << %w[john doe central_uk]
      end
    end
    it { is_expected.to be_falsey }
  end

  context 'with missing cc_name' do
    let(:csv_string) do
      csv_string = CSV.generate do |csv|
        csv << %w[name surname central_uk]
        csv << %w[john doe 1d2fa23]
      end
    end

    it { is_expected.to be_falsey }
  end

  context 'with valid csv' do
    let(:csv_string) do
      csv_string = CSV.generate do |csv|
        csv << %w[name surname cc_cert_id cc_name]
        csv << %w[john doe 1d2fa23 central_uk]
      end
    end

    it { is_expected.to be_truthy }
  end
end
