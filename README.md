# SitingTool

## Urban Stack - Sitting Tools
We propose to develop a set of parcel-level, location-based metrics that represent various dimensions of housing sustainability, including access to open space, access to low-carbon transportation options, and likely commute-generated vehicle miles traveled for parcels across Allegheny County, Pennsylvania. We will also develop a separate set of parcel-level metrics to describe likely housing affordability and the feasibility of housing development. Using these metrics, we will develop an interactive tool that will allow users to specific the relative value or weight they place on affordability, sustainability, and feasibility to identify a set of optimal locations for infill housing development, based user specified values.

The most updated data visualization is available at https://kepler.gl/demo/map?mapUrl=https://dl.dropboxusercontent.com/s/9roo3y1sk3k2t45/keplergl_afm6zp.json 

## Location-based sustainability
### - Preprocessing
We preprocess the data set for two reasons:
1. To unify the coordinate reference system (CRS) of each spatial data set for later calculations. See 03_scripts/ldt_preprocess_CRS.Rmd
2. To generate a parcel centroid data set that contains unique IDs. See /03_scripts/ldt_preprocess_parcelID.Rmd. The proprocessed parcel centroid data set is available at 02_data/parcel/parcel_centroid_uniqueID.geojson.

### - Mode share of non-SOV commute trips
We calculate the mode share of non-SOV commute trips of each parcel using the American Community Survey (ACS) data, which include commute mode share information at the census tract level. The mode share of non-SOV commute trips equals to 1 - (mode share of SOV) for each census tract, which then used as the proxy for all parcels within that census tract.

Script: 03_scripts/ldt_modeShare.Rmd

result: 02_data/modeShare/parcel_centroid_modeShare.csv

### - Daily transit arrivals within 500 meters' walk
We utilize the General Transit Feed Specification (GTFS) data and the r5r package in R to calculate daily transit arrivals within 500 meters' walking distance from each parcel centroid. To get this metric, we first select transit stops within 500 meters' walking distance of each parcel (in this case, the parcel centroid is used as the destination) using the r5r packages. Then, we aggregate daily transit arrivals by synthesizing files from the GTFS data set. For a detailed calculation process, please refer to the script. Note that we calculate daily transit arrivals for a normal weekday.

Script: 03_scripts/ldt_transit_accessibility.Rmd & 03_scripts/ldt_transit_accessibility_routes.Rmd

Result: 02_data/transitAccessibility/parcel_centroid_arrivals.csv

### - Number of open spaces within 1000 meters' walk
OpenStreetMap (OSM) data and the r5r package are used to calculate the number of open spaces within 1000 meters' walk from each parcel centroid. We first obtain all parks in and near the Allegheny County by querying the OSM data using "PARK" as the keyword. Then we extract the centroids of all park area. Finally, we utilize the "accessibility" function from the r5r package to calculate how many parks are within the 1000 meters' walk distance. 

Script: 03_scripts/ldt_POI&park_accessibility.Rmd

Result: 02_data/park/access_park_geom.csv

### - Number of grocery stores within 1000 meters' walk
This metric is calculated following similar steps as the number of accessible open spaces, except a different data source. Instead of OSM, we use the SafeGraph POI data via the "SafeGraph Data for Academics" program. The SafeGraph data is more up-to-date and includes valuable information such as whether or not a store is still open and visitation volumes. Thus, we are able to include only the operating stores. Once we obtain the grocery store data, we utilize the "accessibility" function from the r5r package to calculate the numbers of accessible grocery stores.

Script: 03_scripts/ldt_POI&park_accessibility.Rmd

Result: 02_data/poi/access_grocery_geom.csv

### - Intersection density within 1km radius
We utilize the OSMnx package in Python to generate street network within 1km buffer of each parcel centroid and calculate the network statistics, including average street circuity, average count of streets per node, intersection count, and average edge length. For a complete introduction of the stats, please refer to the OSMnx documentation: https://osmnx.readthedocs.io/en/stable/index.html.

Script: 03_scripts/ldt_buffer_osmnx.ipynb

Result: We are waiting for a supercomputer to finish the calculation :)

It could be tricky to set up the OSMnx package in Python. Thus, please see the following steps for a quick start.

1. Install the latest version of Anaconda (https://www.anaconda.com/).
2. Install Osmnx in Terminal following the instructions (https://osmnx.readthedocs.io/en/stable/). 
3. There could be a chance that you install an older version. Then do the following: 
    - Update your python: conda install -c anaconda python=3.8
    - Update your packages: conda update --all
4. Then you probably need to install jupyterlab: pip install jupyterlab

You should be good to go. Activate the “ox” environment (conda activate ox), and then tap in “jupyter lab” in your terminal.



____

Repo maintained by [Tianyu Su](https://www.tianyu-su.city/).
Data used in this project is stored separately on OneDrive. Please contact the authors for further information. 

#### Authors: Tianyu Su. Carole Voulgaris. Elizabeth Christoforetti.
Harvard University Graduate School of Design,  
48 Quincy St, Cambridge, MA 02138, USA 