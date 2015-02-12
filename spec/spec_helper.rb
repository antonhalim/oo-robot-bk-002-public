require_relative "../lib/robot.rb"

RSpec.configure do |config|

  # helper method to count the number of times an item appears in the hospital hash
  def count_item(robot, item_name, location=nil)
    if location
      robot.hospital[location].count(item_name)
    else
      count = 0
      robot.hospital.each do |location, items|
        count += items.count(item_name)
      end
      count
    end
  end

end

