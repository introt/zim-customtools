#!/bin/bash

# tag-block-aggregator.sh
# free software under GPLv2
# upstream: https://github.com/introt/zim-customtools/tree/main/tag-block-aggregator

# a Zim Wiki custom tool for to
# "Aggregate content based on tag and content block #1590"

# it's used like this:
# [Command] tag-block-aggregator.sh %n Journal %t
# [x] Command does not modify data
# [x] Output should replace current selection
# then select the tag whose blocks you want to aggregate :)
# if you use Zim's "@tags", you won't need to type the "@"

# tag blocks begin with
# "tag: TAG1 [TAGN] --"
# and end with either
# "end: TAG1 [TAGN] --"
# which ends the listed tags, or
# "--"
# which ends all blocks

set -eu

find "$1/$2" -type f -name '*.txt' | sort | xargs gawk -v "nbpath=$1" -v "search_tag=$3" '
BEGINFILE { first = 1 } # everything but 0 and "" are true

/^tag: .* --$/ { # match tag lines
	for ( n = 2; n < NR; n++ ) { # search the tags
		if ( $n == search_tag || $n == "@" search_tag ) {
			# print a link to the page before its first contents
			if ( first ) {
				page = FILENAME
				sub(nbpath, "", page)
				sub(".txt$", "", page)
				gsub("/", ":", page)
				print "=== [[" page "]] ==="
				first = 0
			} else {
				# separate contents
				print "-----"
			}
			content = 1
			depth++ # allows having a tag inside itself
		}
	}
	next # skip to next line
}

# end listed tags
/^end: .* --$/ {
	for ( n = 2; n < NR; n++ ) {
		if ( $n == search_tag ) { depth-- }
	}
	if ( ! depth ) { content = 0 }
	next
}

# end all tags
/^--$/ { depth = 0; content = 0; next }

# print content lines
{ if ( content ) { print } }'
