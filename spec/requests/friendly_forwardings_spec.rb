require 'spec_helper'

describe "FriendlyForwardings" do

  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_registration_path
    # The test automatically follows the redirect to the signin page.
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    # The test follows the redirect again, this time to users/edit.
    response.should render_template('devise/registrations/edit')
  end
end

