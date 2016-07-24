# Introducing the monthly_planner gem

The monthly_planner gem is used to create, and maintain upcoming dates for the month ahead. It allows the user to create, read, update, or delete entries in a plain text file. Here's an example of the monthly-planner.txt file:

<pre>
monthly-planner.txt
===================

08-Aug 9:45am Appointment in building 33
12-Aug Visiting Mrs Smith in Cumbria
19 Aug 1pm Meeting in building 1
</pre>


## Housekeeping

To generate a Dynarex file, or purge old dates, or archive all dates from the monthly-planner.txt file, simply pass the filepath of the txt file to the MonthlyPlanner object and call save e.g.


    require 'monthly_planner'

    mp = MonthlyPlanner.new 'monthly-planner.txt', path: '/tmp'
    mp.save

Notes:

* Upcoming dates are not limited to the current month
* Files are archived by month in a Dynarex format within a subdirectory called 'archive' relative to the path provided e.g. */tmp/archive/2016/mp.xml*
* An entry is restricted to 1 line
* A time for the entry is optional
* The month must be abbreviated
* Valid example dates for the 8th August are as follows: 08-Aug, 08 Aug, 8th Aug, 08-aug

## Resources

* monthly_planner https://rubygems.org/gems/monthly_planner

## See also

* Introducing the weekly_planner gem http://www.jamesrobertson.eu/snippets/2015/dec/06/introducing-the-weekly_planner-gem.html

monthly_planner planner gem month gtd
