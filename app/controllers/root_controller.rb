# frozen_string_literal: true

class RootController < ApplicationController
  def index
    @exchanges = Exchange.all
  end
end
