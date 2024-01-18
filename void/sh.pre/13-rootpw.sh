#!/bin/sh

# root password
root_password="${root_password:-$(chopt "What do you want to set as the root password?" "1234")}"
