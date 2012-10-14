require 'spec_helper'

describe "posts/show" do
  include Devise::TestHelpers
  let(:user) { FactoryGirl.create :user }
  before(:each) do
    @post = FactoryGirl.create :post, user: user
  end

  it "renders attributes" do
    render
    rendered.should have_selector "article" do
      have_selector "h1.title", :text => @post.title, :count => 1
      have_selector ".content", :text => @post.body, :count => 1
    end
  end
end
