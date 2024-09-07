module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      notify_error(e, airbrake_notify: true)
      render_error(500, I18n.t('errors.server_error'))
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      notify_error(e)
      render_error(404, I18n.t('errors.record_not_found'))
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      notify_error(e)
      render_error(422, I18n.t('errors.record_invalid'))
    end

    rescue_from ActionController::ParameterMissing do |e|
      notify_error(e)
      render_error(404, I18n.t('errors.record_invalid'))
    end

    rescue_from JSON::ParserError do |e|
      notify_error(e)
      render_error(404, I18n.t('errors.record_invalid'))
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      notify_error(e)
      render_error(404, I18n.t('errors.record_not_unique'))
    end

    private

    def notify_error(error, airbrake_notify: false)
      airbrake_notify(error) if airbrake_notify
      raise_error(error)
    end

    def raise_error(error)
      if Rails.env.test? || Rails.env.development?
        raise error
      end
    end

    def airbrake_notify(error)
      if Rails.env.production? || Rails.env.staging?
        Airbrake.notify(error)
      end
    end
  end
end
