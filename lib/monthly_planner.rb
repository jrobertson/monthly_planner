#!/usr/bin/env ruby

# file: monthly_planner.rb

require 'date'
require 'dynarex'
require 'fileutils'



class MonthlyPlanner
  
  attr_reader :to_s

  def initialize(filename='monthly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    @dx = new_dx    
  end

  def dx()
    @dx
  end
  
  def save(filename=@filename)

    s = File.basename(filename) + "\n" + dx_to_s(@dx).lines[1..-1].join
    File.write File.join(@path, filename), s
    @dx.save File.join(@path, filename.sub(/\.txt$/,'.xml'))
        
  end
  
  def to_s()
    dx_to_s @dx
  end

  private
  
  def dx_to_s(dx)


    rows = ['']
    title = File.basename(@filename)
    title + "\n" + "=" * title.length + "\n\n%s\n\n" % [rows.join("\n\n")]

  end  
  
  def new_dx()
    
    dx = Dynarex.new 'month[title]/day(date, desc, uid)'

    d = DateTime.now.to_date
    title = %i(itself next_month)\
        .map {|x| d.method(x).call.strftime("%b")}.join(' - ')
    dx.title = "Monthly Planner (%s)" % title

    return dx
  end

end
