class ErrorsController < ApplicationController
  def page_not_found
    render status: 404
  end
end


def internal_server_error
  render status: 500
end
end