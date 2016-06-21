class FeedbackController < ApplicationController
  skip_before_action :validate_cookies
  skip_before_action :verify_authenticity_token, only: :submit

  def index
    @form = FeedbackForm.new(referer: request.referer, user_agent: request.user_agent)
  end

  def submit
    @form = FeedbackForm.new(params['feedback_form'] || old_feedback_form_params || {})
    if @form.valid?
      session_id = cookies[CookieNames::SESSION_ID_COOKIE_NAME]
      if FEEDBACK_SERVICE.submit!(session_id, @form)
        query_params = { "emailProvided" => @form.reply_required?, "sessionValid" => session_id.present? }
        redirect_to feedback_sent_path(query_params)
      else
        @has_email_sending_error = true
        render :index
      end
    else
      flash.now[:errors] = @form.errors[:base].first
      render :index
    end
  end

private

  def old_feedback_form_params
    {
      what: params["what"],
      details: params["details"],
      reply: params["selection"],
      name: params["name"],
      email: params["email"],
      referer: params["referer"],
      user_agent: params["user-agent"],
      js_disabled: params["js-disabled"]
    }
  end
end