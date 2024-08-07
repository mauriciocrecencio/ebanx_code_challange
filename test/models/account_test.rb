require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should not allow non-integer balances" do
    account = Account.new(balance: "abc")
    assert_not account.valid?
    assert_includes account.errors[:balance], "is not a number"
  end

  test "should not allow negative balances" do
    account = Account.new(balance: -10)
    assert_not account.valid?
    assert_includes account.errors[:balance], "must be greater than or equal to 0"
  end
end
