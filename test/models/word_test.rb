require 'test_helper'

class WordInheritor < Word
  define_specifics :test_method_1
  define_specifics :test_method_2, :test_method_3
end

class WordInheritorWoSpecifics < Word
end

class WordTest < ActiveSupport::TestCase

  test "that the default specifics value is an empty hash" do
    assert Word.new.specifics.kind_of?(Hash)
  end

  test "has specifics setters and getters" do
    assert WordInheritor.new.respond_to?(:test_method_1)
    assert WordInheritor.new.respond_to?(:test_method_2)
    assert WordInheritor.new.respond_to?(:test_method_3)
  end

  test "specifics should be empty array if no defined" do
    assert WordInheritorWoSpecifics.specifics == []
  end

  test "specifics setter and getter methods" do
    word_inheritor = WordInheritor.new

    (1..3).each do |method_version|
      word_inheritor.send("test_method_#{method_version}=", "test_value_#{method_version}")
      assert word_inheritor.send(:specifics).fetch("test_method_#{method_version}".to_sym) == "test_value_#{method_version}"
      assert word_inheritor.send("test_method_#{method_version}") == "test_value_#{method_version}"
    end
  end

  test "has list of the defined inheritor classes" do
    assert Word.inheritors.include? WordInheritor
  end

end