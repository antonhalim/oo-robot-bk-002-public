describe "Robot" do

  let(:misson_bay_file_path) { "spec/fixtures/1_mission_bay_hospital.json" }
  let(:mission_bay_hospital) { JSON.parse(File.read(misson_bay_file_path)) } 
  let(:el_camino_file_path) { "spec/fixtures/2_el_camino_hospital.json" }
  let(:el_camino_hospital) { JSON.parse(File.read(el_camino_file_path)) } 
  
  let(:baymax) { Robot.new("Baymax", "pharmacy", misson_bay_file_path) }
  let(:wall_e) { Robot.new("Wall-E", "kitchen", el_camino_file_path) }
  let(:robots) { [baymax, wall_e] }

  describe "#initialize pt. 1" do
    it "accepts three arguments" do
      expect { Robot.new("name", "place", misson_bay_file_path) }.to_not raise_error
    end
  end

  describe "#load_json_file" do
    
    it "accepts a file path as an argument" do
      expect { baymax.load_json_file(misson_bay_file_path) }.to_not raise_error
    end

    it "reads and parses a json file" do
      expect(baymax.load_json_file(misson_bay_file_path)).to eq(mission_bay_hospital)
      expect(baymax.load_json_file(el_camino_file_path)).to eq(el_camino_hospital)
    end
  end

  describe "#initialize pt. 2 and attributes" do

    it "accepts a name, location, and json file path in that order" do
      info = {baymax => ["Baymax","pharmacy"], wall_e => ["Wall-E","kitchen"]}
      info.each do |robot, attrs|
        expect(robot.name).to eq(attrs[0])
        expect(robot.location).to eq(attrs[1])
      end
    end

    it "calls on #load_json_file and passes it the file path" do
      result = baymax.load_json_file(misson_bay_file_path)
      expect_any_instance_of(Robot).to receive(:load_json_file).with(misson_bay_file_path).and_return(result)
      Robot.new("Wall-E", "intensive care", misson_bay_file_path)
    end

    it "saves the return value of #load_json_file as hospital" do
      expect(baymax.hospital).to eq(mission_bay_hospital)
    end

    it "can't change its name" do
      robots.each { |r| expect { baymax.name = "new name" }.to raise_error }
    end

    it "starts 75% charged" do
      robots.each { |r| expect(r.battery).to eq(75) }
    end

  end

  describe "#previous_location=" do
    it "can change its previous location" do
      expect { baymax.previous_location = "pediatric wing" }.to_not raise_error
    end
    it "can tell you its previous location" do
      baymax.previous_location = "pediatric wing"
      expect(baymax.previous_location).to eq("pediatric wing")
    end 
  end

  describe "#battery=" do
    it "can change its battery life" do
      baymax.battery = 100
      expect(baymax.battery).to eq(100)
    end
  end

  describe "#hospital=" do
    it "can change its hospital" do
      baymax.hospital = el_camino_hospital
      expect(baymax.hospital).to eq(el_camino_hospital)
    end
  end

  describe "#location=" do

    it "can change its location" do
      baymax.location = "laundry room"
      expect(baymax.location).to eq("laundry room")
    end

    it "remembers where it used to be" do
      baymax.location = "laundry room"
      baymax.location = "emergency room"
      expect(baymax.previous_location).to eq("laundry room")
    end

    it "loses one battery percentage when it changes locations" do
      original_life = baymax.battery
      ["emergency room", "pharmacy"].each.with_index(1) do |place, i|
        baymax.location = place
        expect(baymax.battery).to eq(original_life - i)
      end
    end

    it "doesn't change if given a new location that is the same as the current location" do
      ["pharmacy", "pediatric wing"].each { |l| baymax.location = l }
      expect(baymax.location).to eq("pediatric wing")
      expect(baymax.previous_location).to eq("pharmacy")
      baymax.location = "pediatric wing"
      expect(baymax.location).to eq("pediatric wing")
      expect(baymax.previous_location).to eq("pharmacy")
    end

    it "doesn't lose any charge if the new location is the same as its current location" do
      baymax.location = "pediatric wing"
      original_battery = baymax.battery
      baymax.location = "pediatric wing"
      expect(baymax.battery).to eq(original_battery)
    end

  end

  describe "#arrange_items_alphabetically" do
    it "rearranges all items in its location alphabetically" do
      ["kitchen", "emergency room"].each do |place|
        baymax.location = place
        sorted_items = baymax.hospital[place].sort
        baymax.arrange_items_alphabetically
        expect(baymax.hospital[place]).to eq(sorted_items)
      end
    end

    it "does not rearrange items in other locations" do
      baymax.location = "kitchen"
      baymax.arrange_items_alphabetically
      laundry = baymax.hospital["laundry room"]
      expect(laundry).to_not eq(laundry.sort)
    end
  end

  describe "#recharge" do
    it "if the charging station is empty, it recharges to 100%" do
      baymax.battery = 20
      baymax.recharge
      expect(baymax.battery).to eq(100)
    end

    it "doesn't recharge if the charging station is not empty" do
      wall_e.battery = 10
      wall_e.recharge
      expect(wall_e.battery).to eq(10)
    end

  end

  describe "#collect_dirty_dishes" do
    it "collects every dirty dish and moves it to the kitchen" do
      robots.each do |robot|
        dirty_dish_count = count_item(robot, "dirty dish")
        robot.collect_dirty_dishes
        robot.hospital.each { |l, i| expect(i).to_not include("dirty dish") unless l == "kitchen" }
        expect(robot.hospital["kitchen"].count("dirty dish")).to eq(dirty_dish_count)
      end
    end

    it "winds up in the kitchen" do
      baymax.collect_dirty_dishes
      expect(baymax.location).to eq("kitchen")
    end
  end

  describe "#do_dishes" do

    it "changes location to kitchen" do
      baymax.location = "pharmacy"
      baymax.do_dishes
      expect(baymax.location).to eq("kitchen")
    end

    it "turns all the dirty dishes in the kitchen into clean dishes" do
      dirty_dish_count = count_item(baymax, "dirty dish", "kitchen")
      clean_dish_count = count_item(baymax, "clean dish", "kitchen")
      total_dishes = dirty_dish_count + clean_dish_count
      baymax.do_dishes
      expect(baymax.hospital["kitchen"].count("clean dish")).to eq(total_dishes)
    end
  end

  describe "#deliver_item" do

    it "accepts two arguments, the name of the item and the destination" do
      expect { baymax.deliver_item("penicillin", "pediatric wing") }.to_not raise_error
    end

    it "finds the item in the hash and moves it to the destination" do
      {
        "penicillin" =>  ["pediatric wing", "pharmacy"], 
        "gluten-free meal" => ["emergency room", "kitchen"]
      }.each do |item, locations|
        baymax.deliver_item(item, locations[0])
        expect(baymax.hospital[locations[1]]).to_not include(item)
        expect(baymax.hospital[locations[0]]).to include(item)
      end
    end

    it "only moves one item at a time" do
      count = 1
      2.times do
        baymax.deliver_item("amoxicillin", "emergency room")
        expect(baymax.hospital["pharmacy"].count("amoxicillin")).to eq(2 - count)
        expect(baymax.hospital["emergency room"].count("amoxicillin")).to eq(count)
        count += 1
      end
    end

    it "changes its location to the place where the item was found and then to the destination" do
      baymax.location = "kitchen"
      baymax.deliver_item("penicillin", "pediatric wing")
      expect(baymax.location).to eq("pediatric wing")
      expect(baymax.previous_location).to eq("pharmacy")
    end

    it "returns an error if the item cannot be found in the hospital" do
      expect(baymax.deliver_item("rare antique lamp", "emergency room")).to eq("item not found")
    end

    it "doesn't add an item to the hospital if the item doesn't exist" do
      baymax.deliver_item("rare antique lamp", "emergency room")
      baymax.hospital do |location, items|
        expect(item).to_not include("rare antique lamp")
      end
    end

  end

  describe "#collect_dirty_laundry" do

    it "moves dirty sheets to the laundry room" do
      dirty_sheet_count = count_item(baymax, "dirty sheet")
      baymax.collect_dirty_laundry
      baymax.hospital.each do |l, i| 
        expect(i).to_not include("dirty sheet") unless l == "laundry room"
      end
      expect(baymax.hospital["laundry room"].count("dirty sheet")).to eq(dirty_sheet_count)
    end

    it "moves dirty gowns to the laundry room" do
      dirty_gown_count = count_item(baymax, "dirty gown")
      baymax.collect_dirty_laundry
      baymax.hospital.each do |l, i| 
        expect(i).to_not include("dirty gown") unless l == "laundry room"
      end
      expect(baymax.hospital["laundry room"].count("dirty gown")).to eq(dirty_gown_count)
    end

    it "moves dirty scrubs to the laundry room" do
      dirty_scrubs_count = count_item(baymax, "dirty scrubs")
      baymax.collect_dirty_laundry
      baymax.hospital.each do |l, i| 
        expect(i).to_not include("dirty scrubs") unless l == "laundry room"
      end
      expect(baymax.hospital["laundry room"].count("dirty scrubs")).to eq(dirty_scrubs_count)
    end

    it "winds up in the laundry room" do
      baymax.location = "kitchen"
      baymax.collect_dirty_laundry
      expect(baymax.location).to eq("laundry room")
    end

  end

  describe "#do_laundry" do

    it "makes the location the laundry room" do
      baymax.location = "kitchen"
      baymax.do_laundry
      expect(baymax.location).to eq("laundry room")
    end

    it "makes all the dirty linens (sheet, gown, scrubs) in the laundry room clean" do
      location = "laundry room"
      linens = ["sheet", "gown", "scrubs"]
      dirty_count = 0
      linens.each { |l| dirty_count += count_item(baymax, "dirty #{l}", location) }
      clean_count = 0
      linens.each { |l| clean_count += count_item(baymax, "clean #{l}", location) }
      baymax.do_laundry
      final_count = 0
      linens.each { |l| final_count += count_item(baymax, "clean #{l}", location) }
      expect(final_count).to eq(dirty_count + clean_count)
    end

  end

end