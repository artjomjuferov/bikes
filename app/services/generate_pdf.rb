require 'csv'

# Returns path to pdf file
class GeneratePdf
  include Memery

  def initialize csv_string:, user:, file_path: 'tmp/certificates'
    @csv_string = csv_string
    @file_path = file_path
    @user = user
  end

  def call
    # hack for prawn
    @body = body
    Prawn::Document.generate(file_full_path) do
      text @body
    end
    file_full_path
  end

  private

  def file_full_path
    Rails.root.join(
      @file_path,
      "#{@user.id}_#{cc_cert_id}_#{cc_name}.pdf",
    )
  end

  def body
    "Certificate #{cc_cert_id} for #{name} #{surname}"
  end

  def name
    csv_values[0]
  end

  def surname
    csv_values[1]
  end

  def cc_cert_id
    csv_values[2]
  end

  def cc_name
    csv_values[3]
  end

  # can be extracted into the concern as it's used in a few services
  memoize def csv_values
    CSV.parse(@csv_string).drop(1).shift
  end
end
