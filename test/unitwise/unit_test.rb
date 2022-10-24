# encoding: UTF-8
require 'test_helper'

describe Unitwise::Unit do

  let(:ms2) { Unitwise::Unit.new("m/s2") }
  let(:kg)  { Unitwise::Unit.new("kg") }
  let(:psi) { Unitwise::Unit.new("[psi]")}
  let(:deg) { Unitwise::Unit.new("deg")}


  describe "#terms" do
    it "must be a collection of terms" do
      _(ms2).must_respond_to :terms
      _(ms2.terms).must_be_kind_of Enumerable
      _(ms2.terms.first).must_be_instance_of Unitwise::Term
    end
  end

  describe "#root_terms" do
    it "must be an array of Terms" do
      _(ms2).must_respond_to :terms
      _(ms2.root_terms).must_be_kind_of Array
      _(ms2.root_terms.first).must_be_instance_of Unitwise::Term
    end
  end

  describe "#scalar" do
    it "must return value relative to terminal atoms" do
      _(ms2).must_respond_to :scalar
      _(ms2.scalar).must_equal 1
      _(psi.scalar).must_almost_equal 6894757.293168361
      _(deg.scalar).must_almost_equal 0.0174532925199433
    end
  end

  describe "#composition" do
    it "must be a multiset" do
      _(ms2).must_respond_to :terms
      _(ms2.composition).must_be_instance_of SignedMultiset
    end
  end

  describe "#dim" do
    it "must be a string representing it's dimensional makeup" do
      _(ms2.dim).must_equal 'L.T-2'
      _(psi.dim).must_equal 'L-1.M.T-2'
    end
  end

  describe "#*" do
    it "should multiply units" do
      mult = kg * ms2
      _(mult.expression.to_s).must_match(/kg.*\/s2/)
      _(mult.expression.to_s).must_match(/m.*\/s2/)
    end
  end

  describe "#/" do
    it "should divide units" do
      div = kg / ms2
      _(div.expression.to_s).must_match(/kg.*\/m/)
      _(div.expression.to_s).must_match(/s2.*\/m/)
    end
  end

  describe "#frozen?" do
    it "should be frozen" do
      kg.scalar
      _(kg.frozen?).must_equal true
    end
  end

  describe "#to_s" do
    it "should return an expression in the same mode it was initialized with" do
      ['meter','m', 'mm', '%'].each do |name|
        _(Unitwise::Unit.new(name).to_s).must_equal(name)
      end
    end
    it "should accept an optional mode to build the expression with" do
      temp_change = Unitwise::Unit.new("degree Celsius/hour")
      _(temp_change.to_s(:primary_code)).must_equal("Cel/h")
      _(temp_change.to_s(:symbol)).must_equal("°C/h")
    end
  end

end
