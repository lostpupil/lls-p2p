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
      payment: {
        record: Payment.where(a: self.id),
        total: Payment.where(a: self.id).sum(:money)
      },
      repaymetn: {
        record: Repayment.where(a: self.id),
      total: Repayment.where(a: self.id).sum(:money)}
    }
  end
end
