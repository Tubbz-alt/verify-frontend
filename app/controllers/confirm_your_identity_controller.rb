class ConfirmYourIdentityController < ApplicationController
  include ViewableIdp
  include JourneyHinting

  def index
    journey_hint_entity_id = attempted_entity_id

    if journey_hint_entity_id.nil?
      cookie_error('missing verify-front-journey-hint')
    else
      @transaction_name = current_transaction.name
      @identity_providers = journey_hint_entity_id.nil? ? [] : retrieve_decorated_singleton_idp_array_by_entity_id(current_identity_providers_for_loa, journey_hint_entity_id)

      if @identity_providers.empty?
        cookie_error("invalid verify-front-journey-hint entity-id #{journey_hint_entity_id}")
      end
    end
  end

private

  def cookie_error(string)
    Rails.logger.warn(string)
    cookies.delete(CookieNames::VERIFY_FRONT_JOURNEY_HINT)
    redirect_to sign_in_path
  end
end
