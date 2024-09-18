module Admin
  module Api
    class AppVersionsController < Admin::Api::AdminBaseController
      def show
        app_version = AppVersion.last
        app_version ||= AppVersion.create!
        render json: app_version.as_json(only: %i[id ios_minimum_version_number android_minimum_version_number])
      end

      def update
        app_version = AppVersion.find(params[:id])
        if app_version.update(app_version_params)
          render json: app_version.as_json(only: %i[id ios_minimum_version_number android_minimum_version_number])
        else
          render_error(400, nil, app_version.errors)
        end
      end

      private

      def app_version_params
        params.permit(:ios_minimum_version_number, :android_minimum_version_number)
      end
    end
  end
end
