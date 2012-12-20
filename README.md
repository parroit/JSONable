JSONable
========

Ruby class which allows objects to be converted to json. 

Just subclass from it and call to_json. Works also with nested class on multiple leves.

One drawback though is that the nested class also needs to inherit from JSONable. Otherwise it would result in "nested_class":"#"

Example: 

    module JSONTest
      class TestXX < JSONable
        attr_reader :a

        def initialize a
          @a = a
        end
      end
    
      class TestX < JSONable
        attr_reader :a
        attr_reader :b
        def initialize
          @a = "So what"
          @b = "I am nested"
          @c = TestXX.new [
            "Ruby",
            "Kicks",
            "Ass"
          ]
    
          # this will crash :-(
          #@d = [] 
          #(0..1).each { |i|
          #  @d << TestXX.new(i)
          #}
        end
      end
    
      class Test < JSONable
        attr_reader :a
        attr_reader :b
        attr_reader :c
        def initialize
          @a = "Hello World"
          @b = 500
          @c = [
            "Arg1",
            "Arg2",
            "Arg3"
          ]
          @d = TestX.new
        end
      end
    end

    test = JSONTest::Test.new
    puts test.to_json

Output:

    {"a":"Hello World","b":"500","c":["Arg1","Arg2","Arg3"],"d":{"a":"So what","b":"I am nested","c":{"a":["Ruby","Kicks","Ass"]}}}
