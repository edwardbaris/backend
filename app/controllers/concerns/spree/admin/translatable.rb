module Spree
  module Admin
    module Translatable
      extend ActiveSupport::Concern

      def edit_translations
        save_translation_values
        flash[:success] = Spree.t('notice_messages.translations_saved')

        redirect_to(edit_polymorphic_path([:admin, @object]))
      end

      private

      def save_translation_values
        translation_params = params[:translation]
        active_translations = Set.new
        current_store.supported_locales_list.each do |locale|
          translation_params.each do |attribute, translations|
            if !translations[locale].blank?
              active_translations << locale
            end
          end
        end

        active_translations = active_translations.to_a

        active_translations.each do |locale|
          translation = @object.translations.find_or_create_by(locale: locale)
          translation_params.each do |attribute, translations|
            translation.public_send("#{attribute}=", translations[locale])
          end
          translation.save!
        end
      end
    end
  end
end
