JSONable
========

Ruby class which allows objects to be converted to json. 

Just subclass from it and call to_json. Works also with nested class on multiple leves.

One drawback though is that the nested class also needs to inherit from JSONable. Otherwise it would result in "nested_class":"#"

