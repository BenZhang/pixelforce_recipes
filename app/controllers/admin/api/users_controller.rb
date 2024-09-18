module Admin
  module Api
    class UsersController < Admin::Api::AdminBaseController
      def index
        users = User.all.order(id: :desc).page(params[:page]).per(params[:perPage] || default_per_page)
        if keywords.present?
          users = users.where('first_name ILIKE ANY ( array[?] ) OR last_name ILIKE ANY ( array[?] ) OR email ILIKE ANY ( array[?] ) or id = ?', @keywords, @keywords, @keywords, @keywords.first.delete('%').to_i)
        end
        pagination_headers(users, 'users')

        respond_to do |format|
          format.json do
            render json: users.as_json(only: %i[id first_name last_name email], methods: :status, for_admin: true)
          end
          format.csv do
            export_resource_csv(users, %w[id first_name last_name status email])
          end
        end
      end

      def create
        user = User.new user_params
        if user.save
          render json: user.as_json(only: %i[id first_name last_name email dob gender])
        else
          render_error(400, nil, user.errors)
        end
      end

      def show
        @user = User.find(params[:id])
        render json: @user.as_json(only: %i[id first_name last_name email dob gender])
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: user.as_json(only: %i[id], for_admin: true)
        else
          render_error(400, nil, user.errors)
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy

        render_success
      end

      def genders
        pagination_headers_for_dropdown('genders')
        render json: User.genders.keys.map { |k| { id: k, name: k } }
      end

      private

      def user_params
        permitted = params.permit(:first_name, :last_name, :dob, :email, :gender, :password)
        permitted.presence || raise(ActionController::ParameterMissing, 'Parameters missing')
      end
    end
  end
end
