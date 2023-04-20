class ApplicationController < ActionController::API
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :authorize_request

  # helper_method :nats_publish
  attr_reader :current_user, :github_user

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
    end
  end

  def current_user
    User.find(@decoded[:user_id]) if @decoded.present?
  end

  # concern github able
  def authorize_github
    github_client = Octokit::Client.new(access_token: current_user.github_token, auto_paginate: true)
  rescue Octokit::BadRequest
    render json: { errors: 'Github token invalid or empty!' }, status: :not_found
  end

  private

  def user_not_authorized
    render json: { error: 'You do not have permission to perform this action' }, status: :forbidden
  end

  # needed to delete? dublicate in concern
  def nats_publish(subject, data)
    require 'nats/client'
    require 'json'

    nats = NATS.connect(ENV['NATS_SERVER_PORT'])
    nats.publish(subject, data)
  end

  # add this
  def render_success(data: nil, status: :ok, serializer: nil)
    if data.nil?
      render json: {}, status: status
    else
      render json: { data: }, status:
    end
  end

  # add this and update
  def render_failure
    render json: { baseErrors: errors }, status:
  end
end
