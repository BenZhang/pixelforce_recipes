module ResponseHandler
  extend ActiveSupport::Concern

  included do
    before_action :config_default_response_settings
  end

  def config_default_response_settings
    set_response_format
  end

  def set_response_format
    self.content_type = 'application/json'
  end

  def render_success
    render json: {}, status: :ok
  end

  def render_no_content
    render json: {}, status: :no_content
  end

  def render_error(status, message, data = nil)
    response = {
      errors: [message]
    }
    response = response.merge(data) if data
    render json: response, status: status
  end
end
