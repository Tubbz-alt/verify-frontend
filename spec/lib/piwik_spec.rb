require "piwik"
require "active_support/core_ext/string"

RSpec.describe Piwik do
  it "should correctly generate a url" do
    piwik = Piwik.new("http://www.example.com:1234/foo", 1)
    expect(piwik.url.to_s).to eql "http://www.example.com:1234/foo"
  end

  it "has a site id" do
    piwik = Piwik.new("https://www.example.com", 5)
    expect(piwik.site_id).to eql 5
  end

  it "is disabled when piwik_host is nil" do
    piwik = Piwik.new(nil, 5)
    expect(piwik.enabled?).to eql false
  end

  it "is disabled when piwik_host is an empty string" do
    piwik = Piwik.new("", 5)
    expect(piwik.enabled?).to eql false
  end

  it "is enabled when piwik_host is present" do
    piwik = Piwik.new("https://www.example.com", 5)
    expect(piwik.enabled?).to eql true
  end

  it "will raise when piwik_host is not valid uri" do
    expect { Piwik.new("foo:: :   :///", 5) }.to raise_error URI::InvalidURIError
  end
end
