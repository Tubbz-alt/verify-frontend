module ViewableIdpPartialController
  def select_viewable_idp_for_sign_in(entity_id)
    for_viewable_idp(entity_id, current_identity_providers_for_sign_in) do |decorated_idp|
      store_selected_idp_for_session(decorated_idp.identity_provider)
      yield decorated_idp
    end
  end

  def select_viewable_idp_for_loa(entity_id)
    for_viewable_idp(entity_id, current_identity_providers_for_loa) do |decorated_idp|
      store_selected_idp_for_session(decorated_idp.identity_provider)
      yield decorated_idp
    end
  end

  def select_viewable_idp_for_single_idp_journey(entity_id)
    for_viewable_idp(entity_id, current_identity_providers_for_single_idp) do |decorated_idp|
      store_selected_idp_for_session(decorated_idp.identity_provider)
      yield decorated_idp
    end
  end


  def for_viewable_idp(entity_id, identity_provider_list)
    matching_idp = identity_provider_list.detect { |idp| idp.entity_id == entity_id }
    idp = IDENTITY_PROVIDER_DISPLAY_DECORATOR.decorate(matching_idp)
    if idp.viewable?
      yield idp
    else
      simple_id = matching_idp.nil? ? nil : matching_idp.simple_id
      logger.error "Unrecognised IdP simple id (#{simple_id}) for entity ID #{entity_id}"
      render_not_found
    end
  end

  def current_identity_providers_for_loa
    CONFIG_PROXY.get_idp_list_for_loa(session[:transaction_entity_id], session[:requested_loa]).idps
  end

  def current_identity_providers_for_sign_in
    CONFIG_PROXY.get_idp_list_for_sign_in(session[:transaction_entity_id]).idps.select(&:authentication_enabled)
  end

  def current_temporarily_unavailable_identity_providers_for_sign_in
    CONFIG_PROXY.get_idp_list_for_sign_in(session[:transaction_entity_id]).idps.select(&:temporarily_unavailable)
  end

  def current_disconnected_identity_providers_for_sign_in
    CONFIG_PROXY.get_idp_list_for_sign_in(session[:transaction_entity_id]).idps.reject(&:authentication_enabled)
  end

  def current_identity_providers_for_rp_sign_in(rp_entity_id)
    CONFIG_PROXY.get_idp_list_for_sign_in(rp_entity_id).idps
  end

  def current_identity_providers_for_single_idp
    CONFIG_PROXY.get_idp_list_for_single_idp(session[:transaction_entity_id]).idps
  end
end
