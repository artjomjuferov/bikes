class Api::LicencesController < ApplicationController
  include Pundit::Authorization

  def create
    unless validate_csv.call
      return head :unprocessable_entity
    end


    head :created
  end

  private

  def validate_csv
    # could be used dry-validation instead
    ValidateCsv.new(csv_string: params[:file].read)
  end
end
