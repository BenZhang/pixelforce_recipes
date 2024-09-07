class Auth::PasswordsController < Devise::PasswordsController
  protected

  def after_resetting_password_path_for(_resource)
    reset_password_success_path
  end
end
