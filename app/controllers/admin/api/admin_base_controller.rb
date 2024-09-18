module Admin
  module Api
    class AdminBaseController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      include ResponseHandler
      include RequestHeaderHandler
      include ExceptionHandler

      before_action :authenticate_admin_user!
      before_action :format_params
      before_action :prepare_pagination_params

      def authenticate_admin_user!
        authenticate_admin_api_admin_user!
      end

      private

      def set_response_format
        if request.format.to_s != 'text/csv'
          request.format = :json
          self.content_type = 'application/json'
        end
      end

      def pagination_headers(collection, item_name)
        headers['Content-Range'] = "#{item_name} #{collection.offset_value}-#{collection.offset_value + collection.limit_value - 1}/#{collection.total_count}"
        headers['Access-Control-Expose-Headers'] = 'Content-Range'
      end

      def pagination_headers_for_dropdown(item_name)
        headers['Content-Range'] = "#{item_name} 0-999/1000"
        headers['Access-Control-Expose-Headers'] = 'Content-Range'
      end

      def default_per_page
        10
      end

      def keywords
        keyword = params[:filter].try(:[], :keyword)
        if keyword.present?
          @keywords = keyword.split(/,|  */).reject(&:blank?).map { |value| "%#{value.strip}%" }
        else
          []
        end
      end

      def export_resource_csv(resources, headers)
        resources = resources.except(:limit, :offset)
        table_name = resources.table_name
        csv_data = CSV.generate(headers: true) do |csv|
          csv << headers.map(&:titleize)
          resources.find_each do |resource|
            csv << headers.map { |header| resource.send(header.parameterize.to_sym) }
          end
        end
        send_data csv_data, filename: "#{table_name}-#{Date.today}.csv"
      end

      def prepare_pagination_params
        if params[:range].present? && params[:range].is_a?(Array) && params[:range].length == 2
          beginning_offset = params[:range][0].to_i
          end_offset = params[:range][1].to_i
          per_page = end_offset - beginning_offset + 1
          params[:perPage] = per_page
          params[:page] = (beginning_offset / per_page) + 1
        end
      end

      def format_params
        if request.method_symbol == :get
          params[:filter] = ActionController::Parameters.new(JSON.parse(params[:filter])) if params[:filter].present? && params[:filter].is_a?(String)
          params[:range] = JSON.parse(params[:range]) if params[:range].present? && params[:range].is_a?(String)
        end
      end
    end
  end
end
