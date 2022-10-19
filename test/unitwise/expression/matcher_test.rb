require 'test_helper'

describe Unitwise::Expression::Matcher do
  describe "::atom(:codes)" do
    subject { Unitwise::Expression::Matcher.atom(:primary_code)}
    it "must be an Alternative list" do
      _(subject).must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse [in_i]" do
      _(subject.parse("[in_i]")).must_equal("[in_i]")
    end
  end
  describe "::metric_atom(:names)" do
    subject { Unitwise::Expression::Matcher.metric_atom(:names)}
    it "must be an Alternative list of names" do
      _(subject).must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'joule'" do
      _(subject.parse('joule')).must_equal('joule')
    end
  end

  describe "::atom(:slugs)" do
    subject { Unitwise::Expression::Matcher.atom(:slugs)}
    it "must be an Alternative list of slugs" do
      _(subject).must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must match 'georgian_year'" do
      _(subject.parse("mean_gregorian_year")).must_equal("mean_gregorian_year")
    end
  end

  describe "::prefix(:symbol)" do
    subject { Unitwise::Expression::Matcher.prefix(:symbol)}
    it "must be an Alternative list of symbols" do
      _(subject).must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse 'h'" do
      _(subject.parse('h')).must_equal('h')
    end
  end
end
