require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  setup do
    @admin_user = build(:admin_user)
  end

  test 'valid admin_user' do
    assert @admin_user.valid?
  end
end
