require 'spec_helper'

describe "User pages" do

  subject { page }
  
  describe "Signup page" do
    before(:each){ visit signup_path }
    let(:submit) { "Create my account" }
    it { should have_selector( 'h1', text: 'Sign up' ) }
    it { should have_selector( 'title', text: full_title('Sign up')) }

    describe "with invalid information" do
      it "should not create user" do
	expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
	before { click_button submit }
	it { should have_content('error') }
	it { should have_selector('title', text: 'Sign up') }
	it { should have_content('Password is too short') }
	it { should have_content('Email is invalid') }
      end
    end
 
    describe "with valid information" do
      before do
	fill_in "Name",			with: "Example User"
	fill_in "Email",		with: "user@example.com"
	fill_in "Password",		with: "password"
	fill_in "Confirm password",	with: "password"
      end
      it "should create a user" do
	expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
	before { click_button submit }	
	it { should have_link("Sign out") }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name ) }
    it { should have_selector('title', text: user.name ) }
  end

  describe "edit" do
    let(:user){ FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector("h1", text: "Update your profile") }
      it { should have_selector("title", text: "Edit user") }
      it { should have_link("Change", href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
	fill_in "Name",			with: new_name
	fill_in "Email",		with: new_email
	fill_in "Password",		with: user.password
	fill_in "Confirm password",	with: user.password
	click_button "Save changes"
      end

      it { should have_selector('title', text: full_title(new_name)) }
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do    

    let(:def_user) { FactoryGirl.create(:user) }
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before do
      sign_in def_user
      visit users_path
    end
    
    it { should have_selector('title', text: 'All Users') }
    it { should have_selector('h1', text: 'All Users') }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
 	  page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
	let(:admin) { FactoryGirl.create(:admin) }
	before do
	  sign_in admin
	  visit users_path
	end

	it { should have_link('delete', href: user_path(User.first)) }
	it "should be able to delete another user" do
	  expect { click_link('delete') }.to change(User, :count).by(-1)
	end
	it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1',	text: user.name) }
    it { should have_selector('title',	text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do

      before { sign_in user }
      let(:other_user) { FactoryGirl.create(:user) }

      describe "following a user" do

        before { visit user_path(other_user) }

        it "should increment the user's followed users count" do
	  expect do
	    click_button "Follow"
	  end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
	  expect do
	    click_button "Follow"
	  end.to change(other_user.followers, :count).by(1)
	end

	describe "toggling the button follow/unfollow" do
	  before { click_button "Follow" }
	  it { should have_selector('input', value: 'Unfollow') }
	end
      end

      describe "unfollowing a user" do

	before do
	  user.follow!(other_user)
	  visit user_path(other_user)
	end

	it "should decrement the user's followed users count" do
	  expect do
	    click_button "Unfollow"
	  end.to change(user.followed_users, :count).by(-1)
	end

	it "should decrement the other user's followers count" do
	  expect do
	    click_button "Unfollow"
	  end.to change(other_user.followers, :count).by(-1)
	end

	describe "toggling the button unfollow/follow" do
	  before { click_button "Unfollow" }
	  it { should have_selector('input', value: "Follow") }
	end
      end
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "in the following page" do
      before do
	sign_in user
	visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: "Following") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "in the followers page" do
      before do
	sign_in other_user
	visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
