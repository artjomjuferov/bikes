class Licence < ApplicationRecord
  belongs_to :user

  validates :pdf_path, presence: true
end
