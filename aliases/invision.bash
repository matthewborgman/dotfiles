#!/usr/bin/env bash

# Define custom aliases for use with Invision

if [ -d "$INVISION_PATH" ]; then

	alias inv="cd $INVISION_PATH"									# inv:		Change to the Invision directory
	alias invbo="cd $INVISION_PATH/../invision-billingoperations"	# invbo:	Change to the Invision Billing Operations directory
	alias invc="cd $INVISION_PATH/../invision-core"					# invc:		Change to the Invision Core directory
	alias invcc="cd $INVISION_PATH/../invision-customercare"		# invcc:	Change to the Invision Customer Care directory
	alias invcnf="cd $INVISION_PATH/../invision-configuration"		# invcnf:	Change to the Invision Configuration directory
	alias invd="cd $INVISION_PATH/../invision-documentation"		# invd:		Change to the Invision Documentation directory
	alias inve2e="cd $INVISION_PATH/../invision-e2e"				# inve2e:	Change to the Invision E2E directory
	alias invr="cd $INVISION_PATH/../invision-reporting"			# invr:		Change to the Invision Reporting directory
	alias invsec="cd $INVISION_PATH/../invision-security"			# invsec:	Change to the Invision Security directory
	alias invstu="cd $INVISION_PATH/../invision-studio"				# invstu:	Change to the Invision Studio directory
	alias invui="cd $INVISION_PATH/../invision-ui"					# invui:	Change to the Invision UI directory
fi