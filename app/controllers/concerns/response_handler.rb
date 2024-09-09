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

  def render_error(status, message, errors = nil, source: nil, meta: {})
    response = {
      'status' => status.to_s,
      'source' => source,
      'errors' => {},
      'meta' => meta
    }
  
    if errors.is_a?(ActiveModel::Errors)
      errors.each do |error|
        attribute = error.attribute.to_s
        error_message = error.message
        response['errors'][attribute] ||= []
        response['errors'][attribute] << error_message
      end
    elsif errors.is_a?(Hash)
      response['errors'] = errors
    else
      response['errors'] = { 'server' => message }
    end
  
    render json: response, status: status
  end
end
