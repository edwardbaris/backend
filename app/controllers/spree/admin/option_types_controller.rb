module Spree
  module Admin
    class OptionTypesController < ResourceController
      include Translatable

      before_action :setup_new_option_value, only: :edit

      def update_values_positions
        ApplicationRecord.transaction do
          params[:positions].each do |id, index|
            Spree::OptionValue.where(id: id).update_all(position: index)
          end
        end

        respond_to do |format|
          format.html { redirect_to spree.admin_product_variants_url(params[:product_id]) }
          format.js { render plain: 'Ok' }
        end
      end

      protected

      def location_after_save
        edit_admin_option_type_url(@option_type)
      end

      private

      def setup_new_option_value
        @option_type.option_values.build if @option_type.option_values.empty?
      end
    end
  end
end
