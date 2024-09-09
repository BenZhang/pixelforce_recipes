module Admin
  module Api
    module V1
      class AvailableModulesController < AdminBaseController
        def index
          render json: [
            {
              "id":   1,
              "name": 'Dashboard',
              "path": '/dashboard'
            },
            {
              "id":   2,
              "name": 'Users',
              "path": '/users'
            }
          ]
        end
      end
    end
  end
end
