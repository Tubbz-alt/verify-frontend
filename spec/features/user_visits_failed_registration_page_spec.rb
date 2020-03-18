require 'feature_helper'
require 'api_test_helper'

RSpec.describe 'When the user visits the failed registration page and' do
  CONTINUE_ON_FAILED_REGISTRATION_RP = 'test-rp-with-continue-on-fail'.freeze
  DONT_CONTINUE_ON_FAILED_REGISTRATION_RP = 'test-rp'.freeze
  CUSTOM_FAIL_PAGE_RP = 'test-rp-no-demo'.freeze

  let(:stub_idp_one) {
    {
        'simpleId' => 'stub-idp-one',
        'entityId' => 'http://idcorp-one.com',
        'levelsOfAssurance' => %w(LEVEL_1 LEVEL_2)
    }.freeze
  }

  let(:stub_idp_two) {
    {
        'simpleId' => 'stub-idp-two',
        'entityId' => 'http://idcorp-two.com',
        'levelsOfAssurance' => %w(LEVEL_1)
    }.freeze
  }

  let(:stub_idp_three) {
    {
        'simpleId' => 'stub-idp-three',
        'entityId' => 'http://idcorp-three.com',
        'levelsOfAssurance' => %w(LEVEL_1)
    }.freeze
  }

  let(:idp_recommendation_engine) { double(:idp_recommendation_engine) }

  before(:each) do
    stub_const('IDP_RECOMMENDATION_ENGINE', idp_recommendation_engine)
    set_session_and_session_cookies!
    stub_api_idp_list_for_loa
    set_selected_idp_in_session(entity_id: 'http://idcorp.com', simple_id: 'stub-idp-one')
  end

  context "two IDPs" do
    before(:each) do
      allow(idp_recommendation_engine).to receive(:get_suggested_idps).and_return(recommended: [IdentityProvider.new(stub_idp_two), IdentityProvider.new(stub_idp_one)])
    end
    context 'relying party is allowed to continue on fail then page rendered' do
      before(:each) do
        page.set_rack_session(transaction_simple_id: CONTINUE_ON_FAILED_REGISTRATION_RP)
      end

      it 'includes expected content for LOA2 journey' do
        set_loa_in_session('LEVEL_2')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.continue_text', rp_name: 'Test RP')
        expect(page).to have_link t('navigation.continue'), href: redirect_to_service_error_path
        expect(page).to have_link t('hub.failed_registration.try_another_company'), href: select_documents_path
      end

      it 'includes expected content for LOA1 journey' do
        set_loa_in_session('LEVEL_1')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.continue_text', rp_name: 'Test RP')
        expect(page).to have_link t('navigation.continue'), href: redirect_to_service_error_path
        expect(page).to have_link t('hub.failed_registration.try_another_company'), href: choose_a_certified_company_path
      end
    end

    context 'relying party is not allowed to continue on fail' do
      before(:each) do
        page.set_rack_session(transaction_simple_id: DONT_CONTINUE_ON_FAILED_REGISTRATION_RP)
      end

      it 'includes expected content when LOA2 journey' do
        set_loa_in_session('LEVEL_2')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.other_ways_summary',
                                       other_ways_description: 'test GOV.UK Verify user journeys')
        expect(page).to have_link t('hub.failed_registration.start_again'), href: select_documents_path
      end

      it 'includes expected content when LOA1 journey' do
        set_loa_in_session('LEVEL_1')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.other_ways_summary',
                                       other_ways_description: 'test GOV.UK Verify user journeys')
        expect(page).to have_link t('hub.failed_registration.start_again'), href: choose_a_certified_company_path
      end
    end
  end

  context "three IDPs" do
    before(:each) do
      allow(idp_recommendation_engine).to receive(:get_suggested_idps).and_return(recommended: [IdentityProvider.new(stub_idp_three), IdentityProvider.new(stub_idp_two), IdentityProvider.new(stub_idp_one)])
    end
    it 'includes expected content for LOA2 journey' do
      set_loa_in_session('LEVEL_2')
      visit '/failed-registration'

      expect_page_to_have_main_content
      expect(page).to have_content t('hub.failed_registration.continue_text', rp_name: 'Test RP')
      expect(page).to have_link t('navigation.continue'), href: redirect_to_service_error_path
      expect(page).to have_link t('hub.failed_registration.try_another_company'), href: select_documents_path
    end

    it 'includes expected content for LOA1 journey' do
      set_loa_in_session('LEVEL_1')
      visit '/failed-registration'

      expect_page_to_have_main_content
      expect(page).to have_content t('hub.failed_registration.continue_text', rp_name: 'Test RP')
      expect(page).to have_link t('navigation.continue'), href: redirect_to_service_error_path
      expect(page).to have_link t('hub.failed_registration.try_another_company'), href: choose_a_certified_company_path
    end

    context 'relying party is not allowed to continue on fail' do
      before(:each) do
        page.set_rack_session(transaction_simple_id: DONT_CONTINUE_ON_FAILED_REGISTRATION_RP)
      end

      it 'includes expected content when LOA2 journey' do
        set_loa_in_session('LEVEL_2')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.other_ways_summary',
                                       other_ways_description: 'test GOV.UK Verify user journeys')
        expect(page).to have_link t('hub.failed_registration.start_again'), href: select_documents_path
      end

      it 'includes expected content when LOA1 journey' do
        set_loa_in_session('LEVEL_1')
        visit '/failed-registration'

        expect_page_to_have_main_content
        expect(page).to have_content t('hub.failed_registration.other_ways_summary',
                                       other_ways_description: 'test GOV.UK Verify user journeys')
        expect(page).to have_link t('hub.failed_registration.start_again'), href: choose_a_certified_company_path
      end
    end
  end

  context 'relying party is not allowed to continue on fail and is custom fail rp' do
    before(:each) do
      allow(idp_recommendation_engine).to receive(:get_suggested_idps).and_return(recommended: [IdentityProvider.new(stub_idp_three), IdentityProvider.new(stub_idp_two), IdentityProvider.new(stub_idp_one)])
      page.set_rack_session(transaction_simple_id: CUSTOM_FAIL_PAGE_RP)
    end

    it 'includes expected content when custom fail LOA2 journey in welsh' do
      set_loa_in_session('LEVEL_2')
      visit '/cofrestru-wedi-methu'
      expect(page).to have_content "This is a custom fail page in welsh."
      expect(page).to have_content "Custom text to be provided by RP."
      expect(page).to have_link t('hub.failed_registration.start_again', locale: :cy), href: select_documents_cy_path
    end

    it 'includes expected content when custom fail LOA2 journey' do
      set_loa_in_session('LEVEL_2')
      visit '/failed-registration'
      expect(page).to have_content "This is a custom fail page."
      expect(page).to have_content "Custom text to be provided by RP."
      expect(page).to have_link t('hub.failed_registration.start_again'), href: select_documents_path
    end
  end

  def expect_page_to_have_main_content
    expect_feedback_source_to_be(page, 'FAILED_REGISTRATION_PAGE', '/failed-registration')
    expect(page).to have_title t('hub.failed_registration.title')
    expect(page).to have_content t('hub.failed_registration.heading', idp_name: 'IDCorp')
    expect(page).to have_content t('hub.failed_registration.contact_details_intro', idp_name: 'IDCorp')
  end
end
