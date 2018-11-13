class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
    Rails.logger.debug("5"*80)
  end
end
