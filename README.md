# Description
Selected notebooks analysing data patterns in New York City. Noise, accident, subway, taxi, uber, toll, and weather data are all compiled in the `resources` directory and used in the `.ipynb` files.  Output graphics from the scripts are stored in the images directory.

# Setup
Run `make all` to retrieve data files. This will use ~50GB of disk space.

# Vector Analysis.ipynb
Examines the distributions of sound, accident, taxi, and subway data over the course of the day as 24-dimensional vectors. Shows calendar plots of the entire year and 2d projections with cluster analysis. Output files stored in the subddirectories of images except subway_model.

# Subway Model.ipynb
Contains a model for point to point subway flows given only inflow. Solved by minimizing the sum of squared differences between the subway point-to-point matrix and a similar, known taxi trip matrix using Gurobi.

# Uber Analysis.ipynb
Plots examining the distributions of uber pickups over the course of the day and comparing it to taxis.

# Weather Analysis.ipynb
Plots showing showing weather pattern correlations.

# Dependencies
* Numpy
* Scipy
* Pandas
* Matplotlib
* NetworkX
* Gurobi
* Tqdm
* Sqlite3
* awk
