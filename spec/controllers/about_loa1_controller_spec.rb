require 'rails_helper'
require 'controller_helper'
require 'api_test_helper'

describe AboutLoa1Controller do
  let(:identity_provider_display_decorator) { double(:IdentityProviderDisplayDecorator) }

  before(:each) do
    stub_api_idp_list_for_loa
  end

  context 'GET about#certified_companies' do
    subject { get :certified_companies, params: { locale: 'en' } }

    before(:each) do
      stub_const('IDENTITY_PROVIDER_DISPLAY_DECORATOR', identity_provider_display_decorator)
      stub_api_idp_list_for_loa(default_idps, 'LEVEL_1')
    end

    it 'renders the certified companies LOA1 template when LEVEL_1 is the requested LOA' do
      set_session_and_cookies_with_loa('LEVEL_1')
      expect(identity_provider_display_decorator).to receive(:decorate_collection).and_return([])
      expect(subject).to render_template(:certified_companies_LOA1)
    end
  end

  context 'GET about#identity_accounts' do
    subject { get :identity_accounts, params: { locale: 'en' } }

    it 'renders the identity accounts LOA1 template when LEVEL_1 is the requested LOA' do
      set_session_and_cookies_with_loa('LEVEL_1')
      expect(subject).to render_template(:identity_accounts_LOA1)
    end
  end
end
