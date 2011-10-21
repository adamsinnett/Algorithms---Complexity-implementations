#!/usr/bin/env ruby

input = ARGV[0].dup

def self.flag unordered 
	high = unordered.length - 1
	low = 0
	i=0
	while (i <= high ) do
		if unordered[i] == 'R'
			unordered[i] = unordered[low]
			unordered[low] = 'R' 
			low+=1
			i+=1
		elsif unordered[i]=='B'
			unordered[i]=unordered[high]
			unordered[high]='B'
			high -=1
		else
			i+=1
		end
	end
	puts unordered

end

flag(input)