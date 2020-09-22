require "partials/viewable_idp_partial_controller"
require "partials/variant_partial_controller"

class SelectDocumentsVariantCController < ApplicationController
  include ViewableIdpPartialController
  include VariantPartialController

  def index
    @form = SelectDocumentsVariantCForm.from_session_storage(selected_answer_store.selected_answers.fetch("documents", {}))
    render :index
  end

  def select_documents
    @form = SelectDocumentsVariantCForm.from_post(params["select_documents_variant_c_form"] || {})
    if @form.valid?
      selected_answer_store.store_selected_answers("documents", @form.to_session_storage)
      idps_available = IDP_RECOMMENDATION_ENGINE_variant_c.any?(current_identity_providers_for_loa_by_variant("c"), selected_evidence, current_transaction_simple_id)
      report_user_evidence_to_piwik(selected_evidence)
      redirect_to idps_available ? choose_a_certified_company_path : select_documents_advice_path
    else
      flash.now[:errors] = @form.errors.full_messages.join(", ")
      render :index
    end
  end

  def advice
    answers = selected_answer_store.selected_answers.fetch("documents", {})
    documents = answers.group_by(&:last)[false].to_h
    if documents.has_key?("has_driving_license") && documents.has_key?("has_credit_card") && documents.size < 4
      documents.delete("has_driving_license")
      documents.delete("has_credit_card")
      documents["has_driving_license_and_credit_card"] = false
    end
    mappings = t("hub_variant_c.select_documents").select { |k, _| k.to_s.start_with?("has") }.transform_keys!(&:to_s)
    documents = documents.transform_keys(&mappings.method(:[]))
    @documents = documents.sort_by { |_, v| v ? 0 : 1 }.to_h

    render :advice
  end

  def prove_your_identity_another_way
    @other_ways_text = current_transaction.other_ways_text
    @service_name = current_transaction.name

    render :prove_your_identity_another_way
  end

private

  def report_user_evidence_to_piwik(selected_evidence)
    FEDERATION_REPORTER.report_user_evidence_attempt(
      current_transaction: current_transaction,
      request: request,
      attempt_number: increase_attempt_number,
      evidence_list: selected_evidence,
    )
  end

  def increase_attempt_number
    session[:evidence_attempt_number] = (session[:evidence_attempt_number] || 0) + 1
  end
end
