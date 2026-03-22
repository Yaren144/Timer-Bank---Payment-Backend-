class PaymentsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    unless user
      render json: { error: "User not found" }, status: :not_found and return
    end

    unless valid_card?(params[:card_number])
      render json: { error: "Invalid card number" }, status: :unprocessable_entity and return
    end

    unless params[:amount].to_i > 0
      render json: { error: "Amount must be greater than 0" }, status: :unprocessable_entity and return
    end

    payment = Payment.new(
      user: user,
      card_number: params[:card_number],
      amount: params[:amount].to_i,
      status: "approved"
    )

    if payment.save
      user.update(time_credits: user.time_credits.to_i + params[:amount].to_i)
      render json: {
        message: "Payment approved",
        time_credits: user.time_credits,
        payment_id: payment.id
      }, status: :created
    else
      render json: { error: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def valid_card?(number)
    number.present? && number.to_s.length.between?(13, 19)
  end
end
