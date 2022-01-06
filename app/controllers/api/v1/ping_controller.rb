class Api::V1::PingController < ApplicationController
  def index
    render_by_key('GENERAL_SUCCESS')
  end
end
