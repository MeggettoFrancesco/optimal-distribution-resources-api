module SharedModelsTest
  def invalid_without(object, attribute)
    object.send("#{attribute}=", nil)
    assert object.invalid?
    assert_not_nil object.errors[attribute.to_sym]
  end
end
