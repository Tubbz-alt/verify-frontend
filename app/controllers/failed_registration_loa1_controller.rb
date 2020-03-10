require 'partials/viewable_idp_partial_controller'
require 'partials/failed_registration_partial_controller'

class FailedRegistrationLoa1Controller < ApplicationController
  include ViewableIdpPartialController
  include FailedRegistrationPartialController

  def index
    @idp = IDENTITY_PROVIDER_DISPLAY_DECORATOR.decorate(selected_identity_provider)
    @transaction = current_transaction
    @decorated_other_idp = other_idp_to_try
    @account = "[your account]"

    if CONTINUE_ON_FAILED_REGISTRATION_RPS.include?(current_transaction_simple_id)
      @continue_rp_partial = @decorated_other_idp.present? ? 'failed_registration/continue_rp_two_idp' : 'failed_registration/continue_rp'
      render 'failed_registration/index_continue_on_failed_registration_LOA1'
    else
      @continue_rp_partial = @decorated_other_idp.present? ? 'failed_registration/non_continue_rp_two_idp' : 'failed_registration/non_continue_rp'
      render 'failed_registration/index_LOA1'
    end
  end
end
