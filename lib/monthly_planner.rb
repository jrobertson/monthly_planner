#!/usr/bin/env ruby

# file: monthly_planner.rb

require 'date'
require 'dynarex'
require 'fileutils'


# The MonthlyPlanner gem can:
#
#  * create a new monthly-planner.txt file
#  * read an existing monthly-planner.txt file

class MonthlyPlanner
  
  attr_reader :to_s

  def initialize(filename='monthly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    
    if File.exists?(fpath) then

      @dx = import_to_dx(File.read(fpath))    
    else
      @dx = new_dx    
    end
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

    rows = dx.all.map do |x| 
      %i(date time desc).map{|y| !x[y].empty? ? x[y] + ' ' : '' }.join
    end
    
    title = File.basename(@filename)
    title + "\n" + "=" * title.length + "\n\n%s\n\n" % [rows.join("\n")]

  end  
  
  def import_to_dx(s)

    regexp = %r{

      (?<day>\d+(?:-|th|[rn]d|st)){0}
      (?<month>#{Date::ABBR_MONTHNAMES[1..-1].join('|')}){0}
      (?<time>\d+[ap]m){0}

      ^(?<date>\g<day>\s*\g<month>)\s*\g<time>?\s*(?<event>.*)
    }x

    dx = new_dx()
    a = LineTree.new(s).to_a

    # Remove the heading
    a.shift 2   

    a.each do |line|
      r = line[0].match(regexp)
      dx.create({date: r['date'], time: r['time'], desc: r['event']})
    end
    
    return dx
  end
  
  def new_dx()
    
    dx = Dynarex.new 'month[title]/day(date, time, desc, uid)', 
                      default_key: :uid

    d = DateTime.now.to_date
    title = [d, d.next_month].map {|x| x.strftime("%b")}.join(' - ')
    dx.title = "Monthly Planner (%s)" % title

    return dx
  end

end