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
        records_in: Payment.where(a: self.id),
        total_in: Payment.where(a: self.id).sum(:money),
        records_out: Payment.where(b: self.id),
        total_out: Payment.where(b: self.id).sum(:money),
      },
      repaymetn: {
        records: Repayment.where(a: self.id),
      total: Repayment.where(a: self.id).sum(:money)}
    }
  end
end
