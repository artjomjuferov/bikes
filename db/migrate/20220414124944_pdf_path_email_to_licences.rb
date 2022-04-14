class PdfPathEmailToLicences < ActiveRecord::Migration[6.0]
  def change
    add_column :licences, :pdf_path, :string
  end
end
