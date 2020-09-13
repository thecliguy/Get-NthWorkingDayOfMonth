################################################################################
# Copyright (C) 2020
# Adam Russell <adam[at]thecliguy[dot]co[dot]uk> 
# https://www.thecliguy.co.uk
# 
# Licensed under the MIT License.
#
################################################################################
# Development Log:
#
# 1.0.0 - 2020-09-12 - Adam Russell
#   * Added '-DayOfMonthToExclude' parameter.
#
# 0.1.0 - 2020-01-25 - Adam Russell
#   * First release.
#
################################################################################

Function Get-NthWorkingDayOfMonth {
    <#
    .SYNOPSIS
        Gets the Nth working day of a specific month and year.
        
    .DESCRIPTION
        Returns the date of the Nth working day in a specified month and year
        as a DateTime object.

        In the event that there is no Nth working day then a terminating error
        is thrown.
        
        By default, the days of a working week are Monday to Friday. This can
        customised with the -WorkingDaysOfWeek parameter.
    
    .EXAMPLE  
        Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020
        
        14 January 2020 00:00:00
        
        # Gets the 10th working day of January 2020.
    
	.EXAMPLE  
        Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -DayOfMonthToExclude 1
        
        15 January 2020 00:00:00
        
        # Gets the 10th working day of January 2020.
        # Excludes the 1st January using the '-DayOfMonthToExclude' parameter.
	
    .EXAMPLE  
        Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -WorkingDaysOfWeek (1..4)
        
        14 January 2020 00:00:00
        
        # Gets the 10th working day of January 2020.
        # Specifies the days of a working week as Mon-Thu using a range of 
        # integers, which are cast as System.DayOfWeek.
        
    .EXAMPLE  
        Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -WorkingDaysOfWeek Monday, Tuesday, Wednesday, Thursday
        
        16 January 2020 00:00:00
        
        # Gets the 10th working day of January 2020.
        # Specifies the days of a working week as Mon-Thu using an array of 
        # strings, the values of which are cast as System.DayOfWeek.
        
    .EXAMPLE  
        Get-NthWorkingDayOfMonth -Nth 10 -Month 1 -Year 2020 -WorkingDaysOfWeek ([System.DayOfWeek]::Monday), ([System.DayOfWeek]::Tuesday), ([System.DayOfWeek]::Wednesday), ([System.DayOfWeek]::Thursday)
        
        16 January 2020 00:00:00
        
        # Gets the 10th working day of January 2020.
        # Specifies the days of a working week as Mon-Thu using an array of 
        # System.DayOfWeek enums.
    
    .LINK
        https://github.com/thecliguy/Get-NthWorkingDayOfMonth/
        https://www.thecliguy.co.uk/2020/01/25/get-the-nth-working-day-of-the-month/
    #>
    
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [ValidateRange(1,31)] 
        [Int]$Nth,
        
        [parameter(Mandatory=$True)]
        [ValidateRange(1,12)] 
        [Int]$Month,
        
        [parameter(Mandatory=$True)]
        [ValidateRange(1,9999)] 
        [Int]$Year,
        
		[parameter(Mandatory=$False)]
		[System.DayOfWeek[]]$WorkingDaysOfWeek = 1..5,
		
		[parameter(Mandatory=$False)]
		[Int[]]$DayOfMonthToExclude
    )
            
    $OrdinalIndicator = Switch -Regex ($Nth) {
        '1(1|2|3)$' { 'th'; break }
        '.?1$'      { 'st'; break }
        '.?2$'      { 'nd'; break }
        '.?3$'      { 'rd'; break }
        default     { 'th'; break }
    }
    
    $DaysInMonth = [DateTime]::DaysInMonth($Year, $Month)
    $NthCounter = 0
    
    Write-Verbose "Calculating the $($Nth)$($OrdinalIndicator) working day ($($WorkingDaysOfWeek -join ", ")) in $((Get-Culture).DateTimeFormat.GetMonthName($Month)) $($Year)..."
    
    For ($i=1; $i -le $DaysInMonth; $i++) {
        $Date = (Get-Date -Month $Month -Year $Year -Day $i).Date
        
		If ($DayOfMonthToExclude -notcontains $Date.Day) {
			If ($WorkingDaysOfWeek -contains $Date.DayOfWeek) {
				$NthCounter++
				Write-Verbose "NthCounter=$($NthCounter): $(Get-Date $Date -Format 'yyyy-MM-dd') $($Date.DayOfWeek)"
			}
		}
        
        If ($NthCounter -eq $Nth) {
            Return $Date
        }
    }
    
	If ($PSBoundParameters.ContainsKey('DayOfMonthToExclude')) {
		$Excluding = ", excluding day(s) of month: $($DayOfMonthToExclude -join ', ')."
	}
	Else {
		$Excluding = "."
	}
	
    Throw "There isn't a $($Nth)$($OrdinalIndicator) working day ($($WorkingDaysOfWeek -join ", ")) in $((Get-Culture).DateTimeFormat.GetMonthName($Month)) $($Year)$($Excluding)"
} 
