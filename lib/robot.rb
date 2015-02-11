require "json"
require "pry"

class Robot

  LINENS = ["gowns", "sheets", "scrubs"]

  attr_accessor :hospital, :previous_location, :battery
  attr_reader :name, :location

  def initialize(name, location, hospital_file_path)
    @hospital = load_json_file(hospital_file_path)
    @location = location
    @name = name
    @battery = 75
  end

  def location=(location)
    self.hospital[previous_location].delete(self.name) if previous_location
    self.previous_location = self.location
    self.battery -= 1
    @location = location
    self.hospital[location] << self.name
  end

  ##############
  ### shared ###
  ##############

  def load_json_file(path)
    JSON.parse(File.read(path))
  end

  def move_all(item_name, final_location)
    count = 0
    hospital.each do |place, items|
      self.location = place
      if items.include?(item_name)
        count += items.count(item_name)
        items.delete(item_name)
      end
    end
    count.times { hospital[final_location] << item_name }
  end

  def move_one(item, original_loation, final_location)
    self.location = original_loation
    temp_a = hospital[location]
    self.hospital[location].delete_at(temp_a.index(item))
    self.location = final_location
    self.hospital[location] << meal
  end

  def replace_item(original_item, final_item, location)
    self.location = location
    count = self.hospital[location].count(original_item)
    self.hospital[location].delete(original_item)
    count.times { self.hospital[location] << final_item }
  end

  ##############
  ### random ###
  ##############

  def arrange_items_alphabetically
    hospital[location] = hospital[location].sort
  end

  def move_to_new_hospital(new_hospital_file_path)
    self.hospital = load_json_file(new_hospital_file_path)
  end

  def recharge
    if self.hospital["charging station"].empty? && self.battery < 100
      self.location = "charging station"
      self.battery = 100
      "charging beep beep...charging beep beep"
    elsif self.battery < 100
      "i don't need to charge"
    else
      "another robot is charging right now"
    end
  end 

  def fire_alarm
    past_location = self.location
    self.location = "against the wall in the #{past_location}"
  end
  
  ############
  ### food ###
  ############

  def collect_dirty_dishes
    move_all("dirty dish", "kitchen")
  end

  def do_dishes
    replace_item("dirty dish", "clean dish", "kitchen")
  end

  def deliver_meal(meal, location)
    move_one(meal, kitchen, location)
  end

  ###############
  ### laundry ###
  ###############

  def collect_dirty_laundry
    LINENS.each { |linen|  move_all("dirty #{linen}", "laundry room")}
  end

  def do_laundry
    LINENS.each do |linen|
      self.public_send("replace_item", "dirty #{linen}", "clean scrubs" "laundry room")
    end
  end

end
