require 'feature_helper'
require 'api_test_helper'

RSpec.feature 'user visits the choose a certified company about idp page', type: :feature do
  before(:each) do
    set_session_and_session_cookies!
    stub_api_idp_list_for_registration
  end

  let(:selected_answers) {
    {
      device_type: { device_type_other: true },
      documents: { passport: true, driving_licence: true },
      phone: { mobile_phone: true }
    }
  }
  let(:given_a_session_with_selected_answers) {
    set_selected_idp_in_session(entity_id: 'http://idcorp.com', simple_id: 'stub-idp-one')
    page.set_rack_session(
      selected_idp_was_recommended: true,
      selected_answers: selected_answers,
    )
  }
  scenario 'user chooses a recommended idp' do
    entity_id = 'my-entity-id'
    stub_api_idp_list_for_registration([{ 'simpleId' => 'stub-idp-one', 'entityId' => entity_id, 'levelsOfAssurance' => %w(LEVEL_1 LEVEL_2) }])
    given_a_session_with_selected_answers
    visit choose_a_certified_company_about_path('stub-idp-one')
    expect(page).to have_content('ID Corp is the premier identity proofing service around.')
    click_button t('hub.choose_a_certified_company.choose_idp', display_name: t('idps.stub-idp-one.name'))
    expect(page).to have_current_path(redirect_to_idp_warning_path)
    expect(page.get_rack_session_key('selected_provider')['identity_provider']).to include('entity_id' => entity_id, 'simple_id' => 'stub-idp-one', 'levels_of_assurance' => %w(LEVEL_1 LEVEL_2))
    expect(page.get_rack_session_key('selected_idp_was_recommended')).to eql true
  end

  scenario 'for a non-existent idp' do
    visit choose_a_certified_company_about_path('foobar')
    expect(page).to have_content t('errors.page_not_found.title')
  end

  scenario 'for an idp that is not viewable' do
    visit choose_a_certified_company_about_path('foobar')
    expect(page).to have_content t('errors.page_not_found.title')
  end

  scenario 'user clicks back link' do
    entity_id = 'my-entity-id'
    stub_api_idp_list_for_registration([{ 'simpleId' => 'stub-idp-one', 'entityId' => entity_id, 'levelsOfAssurance' => %w(LEVEL_1 LEVEL_2) }])
    given_a_session_with_selected_answers
    visit choose_a_certified_company_about_path('stub-idp-one')
    click_link t('navigation.back')
    expect(page).to have_current_path(choose_a_certified_company_path)
  end
end
