#!/bin/bash
# 
# Check a website for the presence of a string. May additionally
# specify a file that contains a line-delimited listing of page names to check
#

# Help
if [ "$#" -eq 0 ]
then
	echo "Usage: webGrep.sh [options]"
	echo ""
	echo "Options:"
	echo "  -u, --url		Base URL to check"
	echo "  -f, --file		Pages to append to URL"
	echo "  -e, --expression	Expression to search page(s) for"
	exit 1;
fi

# Process parameters
while [[ $# > 1 ]]
do
	key="$1"
	case $key in
		-u|--url)
		URL="$2"
		shift
		;;
		-f|--file)
		FILE="$2"
		shift
		;;
		-e|--expression)
		EXPRESSION="$2"
		;;
		*)
			# Unknown parameter
		;;
	esac
	shift
done

echo "Checking ${URL} for '${EXPRESSION}'"

if [ -e "${FILE}" ]
then
	# Terminate url in a slash
	if [ "${URL: -1}" != "/" ]
	then
		URL="$URL/"
	fi

	for file in $(cat "${FILE}"); do
		# Grab URL and check for access violation redirect
		if curl -s "${URL}${file}" | grep -q "${EXPRESSION}"
		then
			echo "TRUE  ${file}"
		else
			echo "FALSE ${file}"
		fi
	done
else
	# Checking just the URL...
	if curl -s "${URL}" | grep -q access_violation
	then
		echo "TRUE  ${URL}"
	else
		echo "FALSE ${URL}"
	fi
fi
