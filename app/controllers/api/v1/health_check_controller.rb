module Api
  module V1
    class HealthCheckController < Api::BaseController
      skip_after_action :track_request
      skip_before_action :authenticate_user!

      def index
        render_success
      end
    end
  end
end
