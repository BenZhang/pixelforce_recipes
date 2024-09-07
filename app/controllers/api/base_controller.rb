module Api
  class BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include ResponseHandler
    include RequestHeaderHandler
    include ExceptionHandler

    protect_from_forgery with: :null_session

    before_action :authenticate_user!
    before_action :minimum_version_check!
    before_action :set_user_timezone
    before_action :create_user_devices!

    after_action :track_request

    private

    def create_user_devices!
      if current_user.present? && device_headers[:device_token].present?
        user_device = UserDevice.find_or_initialize_by(device_token: device_headers[:device_token])

        if user_device.persisted? && user_device.user_id != current_user.id
          user_device.destroy!
          user_device = UserDevice.new(device_token: device_headers[:device_token])
        end

        user_device.user_id = current_user.id
        user_device.app_version = device_headers[:app_version]
        user_device.platform = device_headers[:platform]
        user_device.device_model = device_headers[:device_model]
        user_device.os_version = device_headers[:os_version]
        user_device.app_build_version = device_headers[:app_build_version]
        user_device.save!
      end
    end

    def set_user_timezone
      if user_timezone && current_user && current_user.timezone != user_timezone
        current_user.update(timezone: user_timezone)
      end
    end

    def user_timezone
      @user_timezone ||= device_headers[:user_timezone]
    end

    def minimum_version_check!
      app_version = device_headers[:app_version]
      platform = device_headers[:platform]

      if app_version.present? && platform.present?
        current_app_version = AppVersion.order(id: :desc).first

        if current_app_version.present?
          minimum_version = current_app_version.minimum_version(platform)

          if minimum_version.present? && Gem::Version.new(app_version) < Gem::Version.new(minimum_version)
            render_error(426, I18n.t('api.errors.upgrade_app_version'))
          end
        end
      end
    end

    def track_request
      api_version = request.path.split('/')[2]
      ahoy.track "ApiRequest::#{api_version}", {
        params:   request.filtered_parameters,
        url:      request.original_url,
        response: response.status
      }
    end
  end
end
