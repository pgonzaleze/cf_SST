Author: Pedro González-Espinosa
The University of British Columbia
Date:Aug-28th-2019
Last edit: Jan-26th-2021

Climate Data Operators (CDO) used to generate files for Gonzalez-Espinosa and Donner Cloudiness and Heat-Stress on coral bleaching

## Syntaxis:
<infile.nc>: indicates the file where the data is taken
<outfile.nc>: indicates the file that is created after operators

## Examples of commands/operators you might need:

- Merge all files in a directory
cdo mergetime *.nc <outfile.nc>    # merge files into a single netCDF file
cdo mergetime sst_coraltemp_1985*.nc <outfile.nc>    #  This command would only select files from 1985
cdo select,name=analysed_sst -mergetime sst_coraltemp_1985*.nc <outfile.nc>  #  This command would only select SST(var) files from 1985

-Monthly averages: (1985: Jan, Feb, etc; 1986, Jan, Feb, etc...)
cdo monmean <infile.nc> <outfile.nc>

-Annual averages:
cdo yearmean <infile.nc> <outfile.nc>

-Make the average of all the Jan, Feb etc: (annual cycle)
cdo ymonmean <infile.nc> <outfile.nc>

-The monthly anomaly relative to the long term annual cycle:
cdo sub monmean.nc ymonmean.nc <outfile.nc>

-A running mean analyze data points by creating a series of averages of different subsets of the full data set.
The time of outfile is determined by the time in the middle of all contributing timesteps of infile. 
This can be change with the CDO option –timestat_date <first|middle|last>:
export CDO_TIMESTAT_DATE=last
-To compute the running mean over 7 timesteps (so every week) use: 
cdo runmean,7 <infile.nc> <outfile.nc>
-To compute the running mean over 30 timesteps (so every aprox month) use:
cdo runmean,30 <infile.nc> <outfile.nc>
-To compute the running mean over 30 timesteps (so every aprox 3 months) use:
cdo runmean,90 <infile.nc> <outfile.nc>

- To create a mask depending value
cdo -gtc,15 <infile.nc> <outfile.nc> # greater than costant; this would mask as "1" all values above "15", "0" otherwise.
cdo -ltc,15 <infile.nc> <outfile.nc> # lower than costant; this would mask as "1" all values below "15", "0" otherwise.

-To calculate the number of consecutive days
cdo consects -gtc,0 <infile.nc> <outfile.nc> # greater than costant
cdo consects -ltc,0 <infile.nc> <outfile.nc> # lower than constant
cdo consecsum -gtc,0 <infile.nc> <outfile.nc> # greater than costant

-To select positive values only from an input file and save them in an output file while putting all negative values to 0
setrtoc,rmin,rmax,c  ifile ofile
example: cdo setrtoc,-15,0,0 ifile ofile 

- To compute an anomaly based on the long-term climatology 
cdo -z zip ymonsub <infile1.nc> <infile2.nc> <outfile.nc>

- To remap grid. Let's say change "grid_to_change" to have the same grid size as "grid_origin".
cdo -z zip remapbil,[GRID_ORIGIN.nc] [GRID_TO_CHANGE.nc] [outfile_remaped]  

- For values greater than or equal, and store the values in different file, else other file.
This module selects field elements from infile2 with respect to infile1 and writes them to outfile
cdo ifthen -gec,0 [infile1] [infile2] [outfile_ge0.nc] 

