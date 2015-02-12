require "json"

class Robot

  LINENS = ["gown", "sheet", "scrubs"]

  attr_accessor :hospital, :previous_location, :battery
  attr_reader :name, :location

  def initialize(name, location, hospital_file_path)
    @hospital = load_json_file(hospital_file_path)
    @location = location
    @name = name
    @battery = 75
  end

  def location=(location)
    if self.location != location
      self.previous_location = self.location
      self.battery -= 1
      @location = location
    end
  end

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
    self.location = final_location
  end

  def replace_item(original_item, final_item, location)
    self.location = location
    count = self.hospital[location].count(original_item)
    self.hospital[location].delete(original_item)
    count.times { self.hospital[location] << final_item }
  end

  def deliver_item(item, destination)
    found = false
    self.hospital.each do |location, items|
      if items.include?(item) && location != destination
        self.location = location
        items.delete_at(items.index(item))
        found =  true
      end
    end
    if found
      self.location = destination
      self.hospital[destination] << item
    else
      "item not found"
    end
  end

  def arrange_items_alphabetically
    hospital[location] = hospital[location].sort
  end

  def recharge
    if self.hospital["charging station"].empty?
      self.location = "charging station"
      self.battery = 100
    end
  end

  def collect_dirty_dishes
    move_all("dirty dish", "kitchen")
  end

  def do_dishes
    replace_item("dirty dish", "clean dish", "kitchen")
  end

  def collect_dirty_laundry
    LINENS.each { |linen|  move_all("dirty #{linen}", "laundry room")}
  end

  def do_laundry
    LINENS.each do |linen|
      self.send("replace_item", "dirty #{linen}", "clean scrubs", "laundry room")
    end
  end

end
