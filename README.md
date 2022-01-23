					Israel 4 Data and Code
			  Yoav Benjamini and David Steinberg
	Rotem Rozenblum collated the data and wrote the code file.

This archive contains data and analysis code for the Israel 4
cloud seeding experiment.  The experiment was conducted during
the winters of 2013-14 - 2019-2020.  

Goal:  assess the effect of cloud seeding on rainfall in the
Lake Kinneret watershed. 

The outcome is the average (over reporting rain gauges) of the
rainfall (mm) during the experimental unit.  Rainfall is 
measured at 06:00 UCT each day.

Experimental units were randomly allocated either to "seed" or
"no seed" conditions.  To be randomized, units first were "screened
in" as appropriate for seeding, based on both meteorological and 
operational conditions.  Most units were 24 hours in length, running
from 06:00 UCT to 06:00 the following day, and associated with the 
first of these two calendar dates.  When the decision to screen in 
came late in a 24-hour period, the current period was combined with
the next one, generating a 48-hour unit.  When the decision was made 
earlier, a 24-hour unit was generated.  Most of the units were 24 
hours in length.  Randomization was carried out separately for the 
two types of units.  Units were numbered consecutivel within the 
unit type.

Deviations:  Inadvertently, several randomization envelopes were 
duplicated, opened twice, and used to assign two different units.
The envelope labeled 24-48, and intended for use with a 48-hour 
unit, was opened to randomize a 24-hour unit.  The randomization
analyses respected these errors, so that when phantom allocations
were created and used to analyze the data, these same deviations 
were repeated in the same way they occurred in the experiment.

Analysis:  The analysis exploited a double ratio (DR) statistic.
For both seeded and non-seeded units, we computed the average 
rainfall over all seeded (non-seeded, respectively) units.  
The data summary is the ratio of these two averages.  Then  
matching averages are computed using the forecast rainfall for
each unit.  The forecast ratio serves as a control variate that
helps reduce much of the variability due to natural rainfall 
variance.  The DR statistic is the ratio of these two ratios. 


The "data by day" file contains summary data for the experimental
units:
 -- The unit number (within the unit type)
 -- The unit type (24 or 48 hours)
 -- The seeding allocation (0=no seed, 1=seed)
 -- The winter 
 -- The average rainfall across the reporting rain gauges
 -- The average forecast rainfall (from the COSMO prediction)
    for the same gauges included in the actual rainfall average  