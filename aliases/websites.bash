#!/usr/bin/env bash

# Define custom aliases for use with personal projects

if [ -d "$WEBSITES_PATH" ]; then

	alias puma="cd $WEBSITES_PATH/go.puma.com"		# puma:		Change to the Puma directory
	alias sungem="cd $WEBSITES_PATH/sungemcms.com"	# sungem:	Change to the Sungem directory
	alias websites="cd $WEBSITES_PATH"				# websites:	Change to the websites directory
fi