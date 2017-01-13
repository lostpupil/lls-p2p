class User < Sequel::Model
  include BCrypt

  def password
    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  def detail
    {
      user: {
        id: self.id,
        money: self.money
      },
      payment: Payment.where(a: self.id),
      repaymetn: Repayment.where(a: self.id)
    }
  end
end