#!/bin/sh

# language
[ -z "$language" ] && language="$(chopt "What language do you want to use?" "en_US")"
