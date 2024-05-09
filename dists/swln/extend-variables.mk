##
## Add in the variables FILES and TFILES the list of your files
## and folders specific to your site.
## The items in TFILES must be in the temporary folder tmp.
## You have to write one or more rules in extend-rules.mk to create them.
##

## Fix site version
#SOFT:=SWLN
#SWLN_NAME:=SWLN
#SWMB_VERSION:=3.14.10.0
#SWLN_VERSION:=5.20.$(shell echo $(SWMB_VERSION) | sed -e 's/\./ /g;' | xargs -r printf "%i%02i%02i%03i")
#REVISION:=1

## Protect backslash (double)
## No # in the name (use sed basic replace)!
#LOG_DIR:=%SystemRoot%\\Logs\\Deploy

## Add folder print
#FILES+=print

## Put the name of your IT service / Publisher
## No # in the name (sed basic replace)!
#IT_Team:=IT Team
#PUBLISHER:=CNRS France, RESINFO, Local Network Area
