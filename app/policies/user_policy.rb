class UserPolicy
  def initialize user
    @user = user
  end

  def upload_csv?
    not @user.nil?
  end

  def download_license?
    not @user.licences.empty?
  end

end
