require 'spec_helper'

describe "posts/index" do
  subject { render; rendered }
  before { @posts = assign(:posts, FactoryGirl.create_list(:post, 2)) }

  it {
    should have_selector "article", count: 2
    should have_selector "h1.title",
      :text => @posts.first.title, :count => 1
    should have_selector "h1.title",
      :text => @posts.last.title, :count => 1
    should have_selector "h1.title span",
      :text => @posts.first.user.name, :count => 1
    should have_selector "h1.title span",
      :text => @posts.last.user.name, :count => 1
    should have_selector ".content",
      :text => @posts.first.body, :count => 1
    should have_selector ".content",
      :text => @posts.last.body, :count => 1
  }
end
