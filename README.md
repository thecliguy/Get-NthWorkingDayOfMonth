# Get-NthWorkingDayOfMonth
Gets the Nth working day of a specific month and year

DESCRIPTION
------------
Returns the date of the Nth working day in a specified month and year as a `DateTime` object.

By default, the days of a working week are Monday to Friday. This can customised using the `-WorkingDaysOfWeek` parameter.

USAGE
-----
```
Get-NthWorkingDayOfMonth [-Nth] <Int32> 
                         [-Month] <Int32> 
                         [-Year] <Int32> 
                         [[-WorkingDaysOfWeek] {Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday}]
                         [[-DayOfMonthToExclude] <Int32[]>]
```

EXAMPLES
--------
Get the 10th working day of January 2020:  
```
PS C:\> Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020

14 January 2020 00:00:00
```

Get the 10th working day of January 2020 where a working week consists of the days Monday to Thursday:  
```
PS C:\> Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -WorkingDaysOfWeek Monday, Tuesday, Wednesday, Thursday
        
16 January 2020 00:00:00
```

Get the 10th working day of January 2020, excluding the 1st day of the month as a working day:
```
PS C:\> Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -DayOfMonthToExclude 1

15 January 2020 00:00:00
```

MISC
----
I wrote a blog post in January 2020 which features this script, see [Get the Nth Working Day of the Month](https://www.thecliguy.co.uk/2020/01/25/get-the-nth-working-day-of-the-month/).
