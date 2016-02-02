#!/bin/bash

TO=`echo $PWD | sed -e 's/ /\?/g'`

if [ $# -le 1 ]
then
  echo "Syntax: pokeads #AUTH AUTH1 AUTH2 ... AUTHN AND|OR REF|NON \
                        START_YEAR END_YEAR"
  echo "        #AUTH                 : number of authors"
  echo "        AUTH1 AUTH2 ... AUTHN : author names, N=#AUTH"
  echo "        AND|OR                : how to combine authors (must pick one)"
  echo "        REF|NON               : refereed or non- (must pick one)"
  echo "        START_YEAR [,END_YEAR]: years to search, END optional"
  exit $WRONG_ARGS
fi

NAUTHORS=$1
AUTHORS=""
READABLE=""

for ((a=1; a <= NAUTHORS ; a++)) # until we reach NAUTHORS
do
  TMP=`echo $2 | sed 's/^\(.\).*/\1/'`
  if [ $TMP = "^" ]
  then
    FIRSTAUTHOR=`echo $2 | sed 's/^.\(.*\)/\1/'`
    AUTHORS="$AUTHORS"%5E"$FIRSTAUTHOR"%0D%0A # append 1st author name
    READABLE="$READABLE"^"$FIRSTAUTHOR "
  else
    AUTHORS="$AUTHORS""$2"%0D%0A   # append author names to AUTHORS
    READABLE="$READABLE""$2 "
  fi
  shift                          # shift-left parameters to go to next author
done

# shift is good because we can always use the 2nd (next) parameter

LOGIC=`echo $2 | sed y/andor/ANDOR/` # assign uppercase AND or OR to LOGIC
shift                            # shift left to go to next parameter

REF=`echo $2 | sed y/refno/REFNO/`
if [ $REF = "REF" ]
then
  REF="NO"
  REFREADABLE="YES"
else
  REF="ALL"
  REFREADABLE="NO"
fi
shift

START_YEAR=$2                    # assign start year
shift                            # shift left to go to next parameter

END_YEAR=$2                      # assign end year 

echo "INPUT:"
echo "      Authors: $READABLE"
echo "Combined with: $LOGIC"
echo "     Refereed: $REFREADABLE"
echo "   Start year: $START_YEAR"
echo "     End year: $END_YEAR"
echo

echo "http://adsabs.harvard.edu/cgi-bin/nph-abs_connect?\
db_key=AST&\
db_key=PRE&\
qform=AST&\
arxiv_sel=astro-ph&\
arxiv_sel=cond-mat&\
arxiv_sel=cs&\
arxiv_sel=gr-qc&\
arxiv_sel=hep-ex&\
arxiv_sel=hep-lat&\
arxiv_sel=hep-ph&\
arxiv_sel=hep-th&\
arxiv_sel=math&\
arxiv_sel=math-ph&\
arxiv_sel=nlin&\
arxiv_sel=nucl-ex&\
arxiv_sel=nucl-th&\
arxiv_sel=physics&\
arxiv_sel=quant-ph&\
arxiv_sel=q-bio&\
sim_query=YES&\
ned_query=YES&\
aut_logic="$LOGIC"&\
obj_logic=OR&\
author="$AUTHORS"&\
object=&\
start_mon=&\
start_year="$START_YEAR"&\
end_mon=&\
end_year="$END_YEAR"&\
ttl_logic=OR&\
title=&\
txt_logic=OR&\
text=&\
nr_to_return=200&\
start_nr=1&\
jou_pick="$REF"&\
ref_stems=&\
data_and=ALL&\
group_and=ALL&\
start_entry_day=&\
start_entry_mon=&\
start_entry_year=&\
end_entry_day=&\
end_entry_mon=&\
end_entry_year=&\
min_score=&\
sort=SCORE&\
data_type=AASTeX&\
aut_syn=YES&\
ttl_syn=YES&\
txt_syn=YES&\
aut_wt=1.0&\
obj_wt=1.0&\
ttl_wt=0.3&\
txt_wt=3.0&\
aut_wgt=YES&\
obj_wgt=YES&\
ttl_wgt=YES&\
txt_wgt=YES&\
ttl_sco=YES&\
txt_sco=YES&\
version=1" > /tmp/QueryADS.txt

echo "Wrote query URL to /tmp/QueryADS.txt"

echo "Fetching results from ADS..."
#open -W pokeads.app/
wget -q -i /tmp/QueryADS.txt -O /tmp/nph-abs_connect.txt

echo "Wrote results to /tmp/nph-abs_connect.txt"

tail +5 /tmp/nph-abs_connect.txt > ADS_references.tex
rm /tmp/nph-abs_connect.txt

COUNT=`grep bibitem ADS_references.tex | wc -l | sed s/^\ *//g`
echo "Found ""$COUNT"" papers."
echo "Moved results to ./ADS_references.tex"
echo "Done."

exit 0
