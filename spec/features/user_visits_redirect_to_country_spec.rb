require 'feature_helper'
require 'api_test_helper'

RSpec.describe 'When the user visits the redirect to country page' do
  before(:each) do
    set_session_and_session_cookies!
    stub_transactions_list
    stub_countries_list
  end

  def no_eidas_session
    'no-eidas-session'
  end

  def given_a_session_not_supporting_eidas
    page.set_rack_session(
      transaction_supports_eidas: false
    )
  end

  def given_a_session_supporting_eidas
    page.set_rack_session transaction_supports_eidas: true
  end

  it 'should show something went wrong when visiting redirect to country page directly with session not supporting eidas' do
    given_a_session_not_supporting_eidas

    visit '/redirect-to-country'

    expect(page).to have_content t('errors.something_went_wrong.heading')
  end

  it 'should render choose-a-country page when session set and visiting redirect-to-country directly without choosing a country' do
    given_a_session_supporting_eidas

    visit '/redirect-to-country'

    expect(page).to have_content t('hub.choose_a_country.heading')
    expect(page).to have_css('.country-picker')
  end
end
