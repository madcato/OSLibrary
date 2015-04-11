require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "objectId value" do
    person_one = people(:one)
    assert_equal(person_one.id.to_s, person_one.objectId, "objectId must be equal to the id")
  end
  
#  test "person as_json" do
#     p people(:one).as_json
#   end
end
