# compare 2 files looking for only the lines uniq to the 1st
comm -23 uniq_css uniq_html
# pull out all css selectors (at least those defined by the regex) and
# put each on it's own line (sort and uniqify 'em)
cat styles_css | sed -n 's/[^0-0a-zA-Z_\#\.]*\([\#\.]\{0,1\}[a-zA-Z0-9_]\{1,\}\)[^a-zA-Z0-9\#\._]*/\1\n/gp' | sort | uniq > uniq_css
# login to a site and store cookies (i.e. session info) in local file
curl october.mech.columbia.edu/people/login_ -d "username=cnatali" -d "password=pwd" -c cookies.txt
# Use cookies file to retrieve scenario html and retrieve tags, ids and classes 
# from that html
curl october.mech.columbia.edu/scenarios/1994 -b cookies.txt | python html_tags_ids_classes.py > scenarios_show_html
