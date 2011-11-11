#!/usr/bin/env ruby

require 'rspec'
require 'benchmark' 

# Instance variables to hold comparison count
@mo2comparisons = 0
@qscomparison = 0

# add median method to Arrays
class Array
	def median
		return nil if self.empty?
	
		if self.length.odd?
			return ((self.length) / 2)
		else
			return ((self.length - 1) / 2)
		end
	end
end



# Given two arrays, find the the median of the combined values in the arrays
# in less than O(n) time by using divide and conquer. Only works if items in array
# have implemented greater than and less than.

def median_of_2_arrays (first, second)
	return nil if first.empty? || second.empty?
	return nil if first.length != second.length
	if (first.length == 1)
		if (first[0] < second[0])
			return first[0]
		else
			return second[0]
		end
	else
		# note, ruby array slicing via array[start,length]
		@mo2comparisons += 1
		if (first[first.median] < second[second.median])
			if first.length.odd?
				median_of_2_arrays(first[(first.median),(first.length-first.median)],second[0,(second.length-second.median)])
			else
				median_of_2_arrays(first[(first.median+1),(first.length-first.median-1)],second[0,(second.length-second.median-1)])
			end
		else  # even
			if first.length.odd?
				median_of_2_arrays(first[0,(first.length-first.median)],second[second.median,(second.length-second.median)])
			else
				median_of_2_arrays(first[0,(first.length-first.median-1)],second[(second.median+1),(second.length-second.median-1)])
			end
		end

	end
end

#quicksort from http://opennfo.wordpress.com/2009/02/15/quicksort-in-ruby/
def quicksort(list, p, r)
    if p < r then
    q = partition(list, p, r)
        quicksort(list, p, q-1)
        quicksort(list, q+1, r)
   end
end

def partition(list, p, r)
    pivot = list[r]
    i = p - 1
    p.upto(r-1) do |j|
    	@qscomparison += 1
        if (list[j] <= pivot)
            i = i+1
            list[i], list[j] = list[j],list[i]
        end
    end
    list[i+1],list[r] = list[r],list[i+1]
    return i + 1
end



#Timing our function. Compare it with sorting the combined arrays.
1.upto(15) do |n|
	bmfirst = Array.new(2**n)
	bmfirst.fill { rand(10000)}
	bmfirst.sort
	bmsecond = Array.new(2**n)
	bmsecond.fill { rand(10000)}
	bmsecond.sort
	puts "Array of Size: #{2**n}"
	Benchmark.bm(20) do |x|
  		x.report("Median of 2 arrays:") {median_of_2_arrays(bmfirst,bmsecond) }
  		x.report("Combine, native sort:") { (bmfirst+bmsecond).sort.median }
  		x.report("Combine, quicksort:") { sorted = bmfirst+bmsecond;quicksort(sorted,0,(sorted.length-1)); sorted.median }
	end
	puts "Comparisons: Median of 2: #{@mo2comparisons}"
	puts "             Combine and sort: #{@qscomparison}"
	@mo2comparisons = 0
	@qscomparison = 0
end

# Infile rspec. Call rspec to run these tests
describe "Median of 2 arrays" do
	context "with two standard arrays" do
		before do
			@mo2comparisons = 0
		end
		let(:first) { Array.new }
		let(:second) { Array.new }

		it "should compute the nil if either input array is empty" do
			median_of_2_arrays(first, second).should == nil
		end
		it "should compute nil if the arrays are of different size" do
			first = [1,2]
			second = [1]
			median_of_2_arrays(first,second).should == nil
		end
		it "should compute the smaller value if the two array's only contain one value" do
			first = [1]
			second = [2]
			median_of_2_arrays(first,second).should == 1
		end
		it "should compute the correct value if they are both the same value" do
			first = [7]
			second = [7]
			median_of_2_arrays(first,second).should == 7
		end
		it "should compute the median of 2 arrays for arrays of an even number of elements" do
			first = [1,2]
			second = [2,3]
			combined = (first + second).sort
			answer = combined[combined.median]
			median_of_2_arrays(first,second).should == answer
		end
		it "should compute the median of 2 arrays for arrays of an odd number of elements" do
			first = [1,2,3,3]
			second = [4,5,6,7]
			combined = (first + second).sort
			answer = combined[combined.median]
			median_of_2_arrays(first,second).should == answer
		end
		it "should compute the median of 2 arrays for the array on the midterm" do
			first = [3,7,9,11,26,41,42]
			second = [1,14,18,21,30,33,39]
			combined = (first + second).sort
			answer = combined[combined.median]
			median_of_2_arrays(first,second).should == answer
		end
	end
	context "with random arrays" do
		before do
			@first = Array.new(100)
			@second = Array.new(100)
			@first.fill { rand(1000) }
			@second.fill { rand(1000) }
			@mo2comparisons = 0
		end
		it "should return the median of 2 arrays for a long array of random numbers" do
			@combined = (@first + @second).sort
			answer = @combined[@combined.median]
			median_of_2_arrays(@first.sort,@second.sort).should == answer
		end
	end
end

describe "The median of an array" do
	it "should return nil on empty arrays" do
		array = Array.new
		array.median.should == nil
	end

	it "should return the middle index for an even array" do
		array = Array.new(4,1)
		array.median.should == 1
	end

	it "should return the ceiling index of the middle pair for an odd array" do
		array = Array.new(5,1)
		array.median.should == 2
	end
end