require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "when success" do
    assert_equal("alert-success", bootstrap_class_for(:success))
  end

  test "when error" do
    assert_equal("alert-danger", bootstrap_class_for(:error))
  end

  test "when alert" do
    assert_equal("alert-warning", bootstrap_class_for(:alert))
  end

  test "when notice" do
    assert_equal("alert-info", bootstrap_class_for(:notice))
  end

  test "when else" do
    assert_equal("else", bootstrap_class_for("else"))
  end

end
