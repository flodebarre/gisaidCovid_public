# Notes

To update the data (to be done weekly, when the data are updated on the [ECDC website](https://www.ecdc.europa.eu/en/publications-data/data-virus-variants-covid-19-eueea)), run `loadData.R`. There needs to be some manual checks, because the number or types of variants included in ECDC data sometimes changes. There are controls in the script on the number of different variants, but not on the types (they are renamed and grouped in broader categories, so care and caution are necessary).   
Running the `loadData.R` script generates a `data.RData` file, which is used in the app.  
