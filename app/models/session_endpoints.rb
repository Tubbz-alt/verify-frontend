module SessionEndpoints
  PATH = '/api/session'.freeze
  PATH_PREFIX = Pathname(PATH)
  IDP_LIST_SUFFIX = 'idp-list'.freeze
  SELECT_IDP_SUFFIX = 'select-idp'.freeze
  IDP_AUTHN_REQUEST_SUFFIX = 'idp-authn-request'.freeze
  SESSION_STATE_PATH = "#{PATH}/state".freeze
  CYCLE_THREE_SUFFIX = 'cycle-three'.freeze
  CYCLE_THREE_CANCEL_SUFFIX = "#{CYCLE_THREE_SUFFIX}/cancel".freeze
  PARAM_SAML_REQUEST = 'samlRequest'.freeze
  PARAM_SAML_RESPONSE = 'samlResponse'.freeze
  PARAM_RELAY_STATE = 'relayState'.freeze
  PARAM_ORIGINATING_IP = 'originatingIp'.freeze
  PARAM_ENTITY_ID = 'entityId'.freeze
  PARAM_REGISTRATION = 'registration'.freeze
  PARAM_CYCLE_THREE_VALUE = 'value'.freeze
  COUNTRIES_PATH = '/api/countries'.freeze
  COUNTRIES_PATH_PREFIX = Pathname(COUNTRIES_PATH)

  def countries_endpoint(session_id)
    COUNTRIES_PATH_PREFIX.join(session_id).to_s
  end

  def select_a_country_endpoint(session_id, suffix)
    COUNTRIES_PATH_PREFIX.join(session_id, suffix).to_s
  end

  def session_endpoint(session_id, suffix)
    PATH_PREFIX.join(session_id, suffix).to_s
  end

  def idp_authn_request_endpoint(session_id)
    session_endpoint(session_id, IDP_AUTHN_REQUEST_SUFFIX)
  end

  def cycle_three_endpoint(session_id)
    session_endpoint(session_id, CYCLE_THREE_SUFFIX)
  end

  def cycle_three_cancel_endpoint(session_id)
    session_endpoint(session_id, CYCLE_THREE_CANCEL_SUFFIX)
  end
end
