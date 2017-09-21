#!/usr/bin/env bash

# Define custom aliases for use with Invision

if [ -d "$INVISION_PATH" ]; then

	alias inv="cd $INVISION_PATH"
	alias invbo="cd $INVISION_PATH/../invision-billingoperations"
	alias invc="cd $INVISION_PATH/../invision-core"
	alias invcc="cd $INVISION_PATH/../invision-customercare"
	alias invd="cd $INVISION_PATH/../invision-documentation"
	alias inve2e="cd $INVISION_PATH/../invision-e2e"
	alias invr="cd $INVISION_PATH/../invision-reporting"
	alias invsec="cd $INVISION_PATH/../invision-security"
	alias invstu="cd $INVISION_PATH/../invision-studio"
	alias invui="cd $INVISION_PATH/../invision-ui"
fi