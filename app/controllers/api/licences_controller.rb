class Api::LicencesController < ApplicationController
  include Pundit::Authorization
  include Memery

  def create
    unless UserPolicy.new(current_user).upload_csv?
      return head :unauthorized
    end
    csv_string = params[:file].read

    # could be used dry-validation instead
    unless ValidateCsv.new(csv_string: csv_string).call
      return head :unprocessable_entity
    end

    GeneratePdf.new(csv_string: csv_string, user: current_user).call

    head :created
  end

  private

  # In sake of saving time instead of using proper jwt
  def current_user
    User.find_by(id: Base64.decode64(params[:user_id]))
  end
end
