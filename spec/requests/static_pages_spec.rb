require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before(:each) { visit root_path }
    it { should have_content('Sample App') }
    it { should_not have_selector('title', text: full_title('Home')) }
  end

  describe "Help page" do
    before(:each){ visit help_path }
    it { should have_content('Sample App Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before(:each){ visit about_path }
    it { should have_content('About Us') }
    it { should have_selector('title', text: full_title('About')) }
  end

  describe "Contact page" do
    before(:each){ visit contact_path }
    it { should have_selector('h1', text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end

