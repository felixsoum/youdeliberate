require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "UT-APP-1: Assert bootstrap working when success" do
    assert_equal("alert-success", bootstrap_class_for(:success))
  end

  test "UT-APP-2: Assert bootstrap working when error" do
    assert_equal("alert-danger", bootstrap_class_for(:error))
  end

  test "UT-APP-3: Assert bootstrap working when alert" do
    assert_equal("alert-warning", bootstrap_class_for(:alert))
  end

  test "UT-APP-4: Assert bootstrap working when notice" do
    assert_equal("alert-info", bootstrap_class_for(:notice))
  end

  test "UT-APP-5: Assert bootstrap working when else" do
    assert_equal("else", bootstrap_class_for("else"))
  end

end
