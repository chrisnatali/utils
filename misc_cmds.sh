######################################################################
# Text file munging
######################################################################

# compare 2 files looking for only the lines uniq to the 1st
comm -23 uniq_css uniq_html

# pull out all css selectors (at least those defined by the regex) and
# put each on it's own line (sort and uniqify 'em)
cat styles_css | sed -n 's/[^0-0a-zA-Z_\#\.]*\([\#\.]\{0,1\}[a-zA-Z0-9_]\{1,\}\)[^a-zA-Z0-9\#\._]*/\1\n/gp' | sort | uniq > uniq_css

######################################################################
# Automating web access (when cookies are required)
###################################################################### 

# login to a site and store cookies (i.e. session info) in local file
curl october.mech.columbia.edu/people/login_ -d "username=cnatali" -d "password=pwd" -c cookies.txt

# Use cookies file to retrieve scenario html and retrieve tags, ids and classes 
# from that html
curl october.mech.columbia.edu/scenarios/1994 -b cookies.txt | python html_tags_ids_classes.py > scenarios_show_html

######################################################################
# Profiling Python
# Extremely useful in performance tuning Network Planner
######################################################################

# Use cProfile to generate profiling stats for a python run (example NP harvest run)
python -m cProfile -o profile_output utilities/harvest.py -c production.ini

# Parse out stats from cProfile to plain text
python -c "import pstats; p = pstats.Stats('profile_output'); p.print_stats()" > profile_output.txt

# Parse the profile text file into csv
sed -n '7,${s/^ *//;s/ \{1,\}/,/gp}' profile_output.txt > profile_output.csv

# Descending sort the profile csv by cumtime,percall columns, output the top 30 
# and output only the columns we're interested in
csvsort -rc cumtime profile_output.csv | csvcut -c ncalls,cumtime,percall,'filename:lineno(function)' | head -30

