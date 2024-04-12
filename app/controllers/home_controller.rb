class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end
end

