---
tags: oo, oop, nested resources, data scructures, json
languages: ruby
resources: 3
---

# OO Robot

![tug robot](https://s3-us-west-2.amazonaws.com/web-dev-readme-photos/oo-labs/tug.jpg)

## Background

According to a Wired [article](http://www.wired.com/2015/02/incredible-hospital-robot-saving-lives-also-hate/), the hospital at the University of California Mission Bay has started to use robots to help clean linens, deliver drugs, serve meals, and dispose of waste. 

These robots, known as Tugs, are only four feet tall and travel an average of twelve miles a day while performing their tasks. They avoid bumping into other medical workers and walls with the help of a lazer and twenty-seven infrared and ultrasonic sensors.

Tugs are tapped into the hospital's Wi-Fi which allows for some pretty cool behavours. For instance, when they're alerted that there's a fire via the network, they get out of the way to allow us mortals to escape the building. They can also "hail" an elevator through the internet.

## Objective

Build a robot class that mimics the Tug behaviour.

Your robot will know about the hospital's layout as a hash. Get familiar with the structure of a hospital:

```ruby
{
  "pharmacy" => [
    "amoxicillin",
    "penicillin",
  ],
  "kitchen" => [
    "vegetarian meal",
    "normal meal",
    "dirty dish",
  ],
  "pediatric wing" => [
    "dirty gown", 
    "dirty sheet",
    "dirty dish"
  ],
  "emergency room" => [
    "dirty dish", 
    "dirty scrubs", 
    "dirty sheet"
  ],
  "laundry room"=> [
    "dirty gown",
    "clean sheet",
    "clean gown"
  ],
  "charging station" => [
    "another robot"
  ]
}
```

## Instructions

Take a look at the method descriptions.

##### `load_json_file`

This method will take one argument, a JSON file path. This method should read then parse this file. The return value of this method should be a hash version of the JSON file.

##### `initialize`

Your robot will be initialized with a name, location, and a hospital information json file path. It should start 75% charged and should not be able to change its name.

##### `location=`

Your robot will have a custom `location=` method. This method will save the current location as `previous_loaction` before updating its location. This way, your robot can remember where it came from. Every time your robot moves from one location to another, it loses a 1% of its battery life.

##### `arrange_items_alphabetically`

When the robot does this task, it takes all the items in the location where it is. For instance, if `wall_e` is an instance of the Robot class:

```ruby
wall_e.location
# => "pharmacy"
wall_e.hospital["pharmacy"]
# => [ "penicillin","amoxicillin", "vicoden"]
wall_e.arrange_items_alphabetically
wall_e.hospital["pharmacy"]
# => ["amoxicillin", "penicillin", "vicoden"]
``` 

##### `collect_dirty_dishes`

This robot should move all the "dirty dish" strings to the kitchen. For instance:

```ruby
wall_e.hospital
# => 
# { 
#  "emergency room" => [
#    "dirty dish",
#    "heart monitor"
#  ]
#  "pediatric wing" => [
#    "dirty dish",
#    "clean gown"
#  ],
#  "kitchen"=> [
#    "dirty dish"
#  ]
# }
wall_e.collect_dirty_dishes
# => 
# { 
#  "emergency room" => [
#    "heart monitor"
#  ]
#  "pediatric wing" => [
#    "clean gown"
#  ],
#  "kitchen"=> [
#    "dirty dish",
#    "dirty dish",
#    "dirty dish"
#  ]
# }
```

##### `do_dishes`

The method changes all the dirty dishes in the kitchen into clean dishes.

```ruby

wall_e.hospital["kitchen"]
# => [
#      "dirty dish",
#      "dirty dish",
#      "dirty dish",
#      "rag"
#    ]
walle_e.do_dishes
wall_e.hospital["kitchen"]
# => [
#      "clean dish",
#      "clean dish",
#      "clean dish",
#      "rag"
#    ]

```

##### `deliver_item`

This method should take two arguments, the item to deliver, say "amoxicillin", and a destination, for instance "pediatric wing". The robot should take the item from the pharmacy and add it to the pediatric wing array.

This method should also work for meals. If it's given "vegetarian meal" and "pediatric wing", it should move the meal from the kitchen to pediatrics.

For instance:

```ruby
wall_e.hospital
# => 
# { 
#  "pediatric wing" => [
#    "dirty gown"
#  ],
#  "laundry room"=> [
#    "clean sheet",
#    "clean gown"
#  ]
# }
wall_e.deliver_item("clean gown", "pediatric wing")
wall_e.hospital
# => 
# { 
#  "pediatric wing" => [
#    "dirty gown",
#    "clean gown"
#  ],
#  "laundry room"=> [
#    "clean sheet"
#  ]
# }
```

##### `collect_dirty_laundry` and `do_laundry`

There are two more methods, `collect_dirty_laundry`, which is a lot like `collect_dirty_dishes`, except the robot collects dirty scrubs, dirty sheets, and dirty gowns and puts them in the laundry room.

The final method is `do_laundry`, which is a lot like, you guessed it, `do_dishes`. The robot "goes" to the laundry room and turns all the dirty items clean. For example:

```ruby
wall_e.hospital["laundry room"]
# => [
#      "dirty gown",
#      "dirty scrubs",
#      "dirty sheet",
#      "clean gown",
#      "clean gown"
#    ]
walle_e.do_laundry
wall_e.hospital["laundry room"]
# => [
#      "clean gown",
#      "clean scrubs",
#      "clean sheet",
#      "clean gown",
#      "clean gown"
#    ]
```

##### Getting Started

All your code will go in `lib/robot.rb`. Go ahead and run your testing suite.

## Resources

* [Learn to Program](http://books.flatironschool.com/books/43) - [Creating Classes](http://books.flatironschool.com/books/43?page=113)
* [Ruby Hashes](http://ruby-doc.org/core-2.1.5/Hash.html)
* [Ruby Arrays](http://ruby-doc.org/core-2.1.5/Array.html)
