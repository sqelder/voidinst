#!/bin/sh

# user creation menu
umenu_f() {
    # check create_user
    case "${create_user:-$(chmenu "Do you want to add another user?" "yes" "no")}" in
        [yY]|[yY]es) ;;
        [nN]|[nN]o) return 1 ;;
    esac

    # increment userct
    userct="$((userct+1))"

    # get additional user info if needed
    eval "[ -z \"\$user${userct}_name\" ] && user${userct}_name=\"\$(chopt \"What should the additional user's name be?\" \"user\")\""
    eval "[ -z \"\$user${userct}_name_comment\" ] && user${userct}_name_comment=\"\$(chopt \"What should \$user${userct}_name's full name be?\" \"Default User\")\""
    eval "[ -z \"\$user${userct}_password\" ] && user${userct}_password=\"\$(chopt \"What should the password for \$user${userct}_name be?\" \"1234\")\""
    eval "[ -z \"\$user${userct}_groups\" ] && user${userct}_groups=\"\$(chopt \"What groups should \$user${userct}_name be in?\" \"$DEFAULTGROUPS\")\""

    unset create_user
    return 0
}

# initialize userct
userct="0"

# run the user loop
while [ "${mk_users:-1024}" -gt "$userct" ]; do
    umenu_f && {
        continue
    } || {
        break
    }
done

# ensure the new users are created
[ "$userct" -gt 0 ] && create_user="y"
