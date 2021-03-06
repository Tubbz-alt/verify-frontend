module Display
  ViewableIdentityProvider = Struct.new(
    :identity_provider,
    :display_data,
    :logo_path,
    :white_logo_path,
  ) do
    delegate :entity_id,
             :simple_id,
             :model_name,
             :to_key,
             :authentication_enabled,
             :unavailable,
             to: :identity_provider

    delegate :display_name,
             :about_content,
             :requirements,
             :special_no_docs_instructions,
             :no_docs_requirement,
             :contact_details,
             :interstitial_question,
             :interstitial_explanation,
             :mobile_app_installation,
             :tagline,
             to: :display_data

    def viewable?
      true
    end
  end
end
