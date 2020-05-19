module CookieNames
  SESSION_COOKIE_NAME = "_verify-frontend_session".freeze
  SESSION_ID_COOKIE_NAME = "x_govuk_session_cookie".freeze
  PERSISTENT_SESSION_ID_COOKIE_NAME = "_verify-persistent-session-id".freeze
  VERIFY_FRONT_JOURNEY_HINT = "verify-front-journey-hint".freeze
  VERIFY_SINGLE_IDP_JOURNEY = "verify-single-idp-journey".freeze
  VERIFY_LOCALE = "x_verify_locale".freeze
  PIWIK_USER_ID = "PIWIK_USER_ID".freeze
  NO_CURRENT_SESSION_VALUE = "no-current-session".freeze
  AB_TEST = "ab_test".freeze
  AB_TEST_TRIAL = "ab_test_trial".freeze
  ANALYTICS_SESSION_COOKIE_PREFIX = "_pk_id.".freeze
  THROTTLING = "throttling".freeze

  def self.session_cookies
    [SESSION_ID_COOKIE_NAME, SESSION_COOKIE_NAME]
  end

  def self.all_cookies
    session_cookies.push VERIFY_FRONT_JOURNEY_HINT
  end
end
