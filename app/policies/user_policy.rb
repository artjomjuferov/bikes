class UserPolicy
  def initialize user
    @user = user
  end

  def upload_csv?
    not @user.nil?
  end

end
