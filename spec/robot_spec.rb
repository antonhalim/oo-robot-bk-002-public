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

  end

end