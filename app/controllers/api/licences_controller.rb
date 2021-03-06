class Api::LicencesController < ApplicationController
  include Pundit::Authorization
  include Memery

  def create
    unless UserPolicy.new(current_user).upload_csv?
      return head :unauthorized
    end

    unless params[:file]
      return head :unprocessable_entity
    end

    csv_string = params[:file].read

    # could be used dry-validation instead
    unless ValidateCsv.new(csv_string: csv_string).call
      return head :unprocessable_entity
    end

    pdf_path = GeneratePdf.new(
      csv_string: csv_string,
      user: current_user
    ).call

    current_user.licences.create! pdf_path: pdf_path

    UserMailer.certification_received(
      user: current_user,
      pdf_path: pdf_path
    ).deliver

    head :created
  end

  def index
    unless UserPolicy.new(current_user).download_licence?
      return head :unauthorized
    end

    licence = current_user.licences.last

    send_data licence.pdf_path
  end

  private

  # In sake of saving time instead of using proper jwt
  def current_user
    return unless params[:user_id]
    User.find_by(id: Base64.decode64(params[:user_id]))
  end
end
