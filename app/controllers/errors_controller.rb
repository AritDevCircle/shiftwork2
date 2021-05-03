class ErrorsController < ApplicationController
  def page_not_found
    render status: 404
  end
end
