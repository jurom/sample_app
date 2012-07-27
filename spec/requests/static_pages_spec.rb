require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end
  end

  describe "Help page" do

    if "should have the content 'Sample App Help'" do
      visit '/static_pages/home'
      page.should have_content('Sample App Help')
    end
  end
end

