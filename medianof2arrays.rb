#!/usr/bin/env ruby

require 'rspec'

# add median method to Arrays
class Array
	def median
		return nil if self.empty?
	
		if self.length.odd?
			return ((self.length + 1) / 2)
		else
			return (self.length / 2)
		end
	end
end

# Given two arrays, find the the median of the combined values in the arrays
# in less than O(n) time by using divide and conquer

def median_of_2_arrays (first, second)
	return nil if first.empty? || second.empty?
	if (first.length == 1)
		if first[0] > second[0]
			puts second
		else
			puts first
		end
	else
		if first[first.median] < second[second.median]
			if first.length.odd?
				first_upper = first.median - 1
				second_lower = second.median + 1
			else
				first_upper = first.median
				second_lower = second.median + 1
			end
			first_lower = 0
			second_upper = second.length 
		else 
			if first.length.odd?
				first_lower = first.median + 1
				second_upper = second.median - 1
			else
				first_lower = first.median + 1
				second_upper = second.median
			end
			first_upper = first.length 
			second_lower = 0
		end
		median_of_2_arrays(first[first_lower...first_upper], second[second_lower...second_upper])
	end
end

describe "median of 2 arrays" do
	context "2 array utilities" do
		let(:first) { Array.new }
		let(:second) { Array.new }
		it "should return the nil if either input array is empty" do
			median_of_2_arrays(first, second).should == nil
		end
		it "should return the smaller value if the two array's only contain one value" do
			first = [1]
			second = [2]
			median_of_2_arrays(first,second).should == 2
		end
	end
end

describe "array median" do
	it "returns nil on empty arrays" do
		array = Array.new
		array.median.should == nil
	end

	it "returns the middle index for an even array" do
		array = Array.new(4,1)
		array.median.should == 2
	end

	it "returns the ceiling of the middle for an odd array" do
		array = Array.new(5,1)
		array.median.should == 3
	end
end