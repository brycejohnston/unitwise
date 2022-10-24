require 'test_helper'

describe Unitwise::Atom do
  subject { Unitwise::Atom }
  describe "::data" do
    it "must have data" do
      _(subject.data).must_be_instance_of Array
      _(subject.data.count).must_be :>, 0
    end
  end

  describe "::all" do
    it "must be an Array of instances" do
      _(subject.all).must_be_instance_of Array
      _(subject.all.first).must_be_instance_of Unitwise::Atom
    end
  end

  describe "::find" do
    it "must find atoms" do
      _(subject.find("m")).must_be_instance_of Unitwise::Atom
      _(subject.find("V")).must_be_instance_of Unitwise::Atom
    end
  end

  let(:second)  { Unitwise::Atom.find("s") }
  let(:yard)    { Unitwise::Atom.find("[yd_i]")}
  let(:pi)      { Unitwise::Atom.find("[pi]")}
  let(:celsius) { Unitwise::Atom.find("Cel")}
  let(:pfu)     { Unitwise::Atom.find("[PFU]")}
  let(:joule)   { Unitwise::Atom.find("J")}
  describe "#scale" do
    it "must be nil for base atoms" do
      _(second.scale).must_be_nil
    end
    it "sould be a Scale object for derived atoms" do
      _(yard.scale).must_be_instance_of Unitwise::Scale
    end
    it "must be a FunctionalScale object for special atoms" do
      _(celsius.scale).must_be_instance_of Unitwise::Functional
    end
  end

  describe "#base?" do
    it "must be true for base atoms" do
      _(second.base?).must_equal true
    end
    it "must be false for derived atoms" do
      _(yard.base?).must_equal false
      _(pi.base?).must_equal false
    end
  end

  describe "#derived?" do
    it "must be false for base atoms" do
      _(second.derived?).must_equal false
    end
    it "must be true for derived atoms" do
      _(yard.derived?).must_equal true
      _(celsius.derived?).must_equal true
    end
  end

  describe "#metric?" do
    it "must be true for base atoms" do
      _(second.metric?).must_equal true
    end
    it "must be false for english atoms" do
      _(yard.metric?).must_equal false
    end
  end

  describe "#special?" do
    it "must be true for special atoms" do
      _(celsius.special?).must_equal true
    end
    it "must be false for non-special atoms" do
      _(second.special?).must_equal false
    end
  end

  describe "#arbitrary?" do
    it "must be true for arbitrary atoms" do
      _(pfu.arbitrary?).must_equal true
    end
    it "must be false for non-arbitrary atoms" do
      _(yard.arbitrary?).must_equal false
      _(celsius.arbitrary?).must_equal false
    end
  end

  describe "#terminal?" do
    it "must be true for atoms without a valid measurement atom" do
      _(second.terminal?).must_equal true
      _(pi.terminal?).must_equal true
    end
    it "must be false for child atoms" do
      _(yard.terminal?).must_equal false
    end
  end

  describe "#scalar" do
    it "must return scalar relative to terminal atom" do
      _(second.scalar).must_equal 1
      _(yard.scalar).must_almost_equal 0.9144
      _(pi.scalar).must_almost_equal 3.141592653589793
    end
  end

  describe "#dim" do
    it "must return the dim" do
      _(second.dim).must_equal 'T'
      _(yard.dim).must_equal 'L'
      _(joule.dim).must_equal 'L2.M.T-2'
    end
  end

  describe "#measurement=" do
    it "must create a new measurement object and set attributes" do
      skip("need to figure out mocking and stubbing with minitest")
    end
  end

  describe "#frozen?" do
    it "should be frozen" do
      _(second.frozen?).must_equal true
    end
  end

  describe "validate!" do
    it "returns true for a valid atom" do
      atom = Unitwise::Atom.new(
        primary_code: "warp",
        secondary_code: "[warp]",
        names: ["Warp", "Warp Factor"],
        scale: {
          value: 1,
          unit_code: "[c]"
        }
      )

      _(atom.validate!).must_equal true
    end

    it "returns an error for an atom with missing properties" do
      atom = Unitwise::Atom.new(names: "hot dog")

      assert_raises { atom.validate! }
    end

    it "returns an error for an atom that doesn't resolve" do
      atom = Unitwise::Atom.new(
        primary_code: "feels",
        secondary_code: "FEELS",
        names: ["feels"],
        scale: {
          value: 1,
          unit_code: "hearts"
        }
      )

      assert_raises { atom.validate! }
    end
  end
end
