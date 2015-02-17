require 'pry'
require 'JSON'
require 'rest_client'

class Robot

  attr_reader :name, :location
  attr_accessor :hospital, :previous_location, :battery

  def initialize(name, location, file_path)
    @name = name
    @location = location
    @hospital = load_json_file(file_path)
    @battery = 75
  end

  def load_json_file(file_path)
    JSON.parse(File.read(file_path))
  end

  def location=(location)
    # binding.pry
    if location != @location
      @previous_location = @location
      @location = location
      @battery -=1
    end
  end

  def arrange_items_alphabetically
    if self.hospital[location] != self.hospital[location].sort
      self.hospital[location].sort!
    @battery -=2
    end
  end

  def recharge
      if @hospital["charging station"].empty?
        @battery = 100
        @previous_location = @location
        @location = "charging station"
      end
  end

  def collect_dirty_dishes
      @location = "kitchen"
  end

  def do_dishes
    @previous_location = @location
    @location = "kitchen"
  end

  def deliver_item(item, destination)
    unless @hospital.to_a.flatten.include? item
      return "item not found"
    end
    @hospital.each do |place, things|
      things.each do |thing|
        if thing == item
          self.location = place
          i = things.index(item)
          delivery_item = things.delete_at(i)
          self.location = destination
          @hospital[destination] << item
        end
      end
    end
  end

  def collect_dirty_laundry
    dirty_shit = ["dirty gown", "dirty sheet", "dirty scrubs"]
    @hospital.each do |place, things|
      things.each do |thing|
        if dirty_shit.include? (thing)
          deliver_item(thing, "laundry room")
        end
      end
    end
  end

  def do_laundry
    @previous_location = self.location
    @location = "laundry room"

    @hospital["laundry room"].each do |laundry|
      if laundry.match(/\Adirty\s\w+\z/)
      laundry.gsub!(/dirty/, "clean")
    end
    end
  end









end
