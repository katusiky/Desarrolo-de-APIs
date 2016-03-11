require 'rails_helper'

RSpec.describe "my_apps/edit", type: :view do
  before(:each) do
    @my_app = assign(:my_app, MyApp.create!(
      :user => nil,
      :title => "MyString",
      :app_id => "MyString",
      :javascript_origins => "MyText",
      :secret_key => "MyString"
    ))
  end

  it "renders the edit my_app form" do
    render

    assert_select "form[action=?][method=?]", my_app_path(@my_app), "post" do

      assert_select "input#my_app_user_id[name=?]", "my_app[user_id]"

      assert_select "input#my_app_title[name=?]", "my_app[title]"

      assert_select "input#my_app_app_id[name=?]", "my_app[app_id]"

      assert_select "textarea#my_app_javascript_origins[name=?]", "my_app[javascript_origins]"

      assert_select "input#my_app_secret_key[name=?]", "my_app[secret_key]"
    end
  end
end
