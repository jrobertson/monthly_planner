#!/usr/bin/env ruby

# file: monthly_planner.rb

require 'date'
require 'dynarex'
require 'chronic'
require 'fileutils'
require 'fuzzy_match'


# The MonthlyPlanner gem can:
#
#  * create a new monthly-planner.txt file
#  * read an existing monthly-planner.txt file
#  * archive and synchronise entries from the monthly-planner with the archive


class RecordX
  
  def date
    Chronic.parse(@date)
  end
  
end

class MonthlyPlanner
  
  attr_reader :to_s

  def initialize(filename='monthly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    
    if File.exists?(fpath) then

      @dx = import_to_dx(File.read(fpath))    
      sync_archive(@dx.all)
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
   
    title = File.basename(@filename)
    title + "\n" + "=" * title.length + "\n\n%s\n\n" % [dx.to_s(header: false)]

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
    
    dx = Dynarex.new 'month[title]/day(date, time, desc)', default_key: :uid

    d = DateTime.now.to_date
    title = [d, d.next_month].map {|x| x.strftime("%b")}.join(' - ')
    dx.title = "Monthly Planner (%s)" % title

    return dx
  end
  
  
  def sync_archive(dxrows=@dx.all)  
    
    # group by month
    a = dxrows.group_by {|x| x.date.strftime("%b").downcase}

    # add the file to the archive.

    a.each do |month, days|

      d = days.first.date
      
      archive_path = File.join(@path, d.year.to_s, month)
      FileUtils.mkdir_p archive_path
      filepath = File.join archive_path, 'mp.xml'

      if File.exists? filepath then

        dx2 = Dynarex.new filepath

        days.each do |day|

          # determine if the entry already exists in the Dynarex doc

          rows = dx2.to_s(header: false).lines.map(&:chomp)
          fm = FuzzyMatch.new rows
          found, score = fm.find_with_score %i(date time desc)\
                                        .map {|y| day[y]}.join ' '      
          if score < 0.7 then  
            dx2.create(day)
          else
            i = rows.index found        
            dx2.update(dx2.all[i].id, day)
          end

        end


      else

        # if the index.xml file doesn't exist just save them

        dx2 = Dynarex.new dx.schema
        dx2.title = "Monthly Planner #{month.capitalize}-#{d.year}"
        dx2.import days

      end

      dx2.save filepath

    end
    
  end

end