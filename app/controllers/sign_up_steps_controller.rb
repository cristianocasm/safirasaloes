class SignUpStepsController < ApplicationController
  include Wicked::Wizard
  steps :contact_info

  def show; render_wizard; end
end
