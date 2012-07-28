require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end

    it "should have the title 'Sample App | Home'" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Sample App | Home")
    end
  end

  describe "Help page" do

    it "should have the content 'Sample App Help'" do
      visit '/static_pages/help'
      page.should have_content('Sample App Help')
    end

    it "should have the title 'Sample App | Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "Sample App | Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end

    it "should have the title 'Sample App | About Us'" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "Sample App | About Us")
    end
  end
end

