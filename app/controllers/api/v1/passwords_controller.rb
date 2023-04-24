class Api::V1::PasswordsController < ApplicationController
  include NatsPublisher
  skip_before_action :authorize_request, only: %i[reset_password forget_password]

  # render_success / errors
  def forget_password
    return render json: { errors: 'Email not present' } if params[:email].blank?

    user = User.find_by(email: params[:email])

    if user.present?
      user.generate_password_token!
      # SEND EMAIL HERE

      # concorn nats_publish nuts able
      nats_publish('service.mail', { class: 'account',
                                     type: 'account_reset_password',
                                     language: 'en',
                                     to: user.email,
                                     token: user.reset_password_token,
                                     username: user.first_name }.to_json)
      render json: { status: 'ok' }, status: :ok
    else
      render json: { errors: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset_password
    return render json: { errors: 'Token not present' } if params[:email].blank?

    user = User.find_by(reset_password_token: params[:token])

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { status: 'ok' }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end

  def update_password
    unless current_user.authenticate(params[:old_password])
      return render json: { errors: 'Old password is incorrect' }, status: :unprocessable_entity
    end

    # TODO: need to add password validation
    if current_user.update(password: params[:password]) # current_user.save(validate: false)

      render_success(data: current_user, serializer: Api::V1::UserSerializer)
    else
      render_error(errors: current_user.errors.full_messages)
    end
  end
end
