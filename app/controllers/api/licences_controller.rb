class Api::LicencesController < ApplicationController
  include Pundit::Authorization

  def create
    unless csv_validator.call
      return head :unprocessable_entity
    end

    head :created
  end

  private

  def csv_validator
    CsvValidator.new(csv_string: params[:file].read)
  end
end
