# NOTE

This script no longer works. 
I need to update it to work with the current ADS API: https://github.com/adsabs/adsabs-dev-api/blob/master/API_documentation_UNIXshell/Search_API.ipynb

That's on my todo list.

# Old instructions

pokeADS searches the ADS abstract repository for papers and outputs a .tex file with \bibitem references ready to insert you you LaTeX file.

Syntax: pokeads #AUTH AUTH1 AUTH2 ... AUTHN AND|OR REF|NON START_YEAR END_YEAR

 #AUTH                 : number of authors
 AUTH1 AUTH2 ... AUTHN : author names, N=#AUTH
 AND|OR                : how to combine authors (must pick one)
 REF|NON               : refereed or non- (must pick one)
 START_YEAR [,END_YEAR]: years to search, END optional
