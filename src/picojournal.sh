#!/bin/bash

# export config file
# shellcheck disable=SC1091
source .picojournal


## Check if DATA_PATH is set
if [ -z "$DATA_PATH" ]; then
        DATA_PATH=$HOME/.picojournal
fi

## Check if DEFAULT_EDITOR is set
if [ -z "$DEFAULT_EDITOR" ]; then
        if [ -x "$(command -v nano)" ]; then
                DEFAULT_EDITOR=nano
        else
            if [ -x "$(command -v vim)" ]; then
                DEFAULT_EDITOR=vim
            else
                if [ -x "$(command -v vi)" ]; then
                    # shellcheck disable=SC2209
                    DEFAULT_EDITOR=vi
                else
                    if [ -x "$(command -v emacs)" ]; then
                        DEFAULT_EDITOR=emacs
                    fi
                fi
            fi
        fi

        if [ -z "$DEFAULT_EDITOR" ]; then
                echo "No default editor found"
                echo "Please set DEFAULT_EDITOR in .picojournal in home folder"
                exit 1
        fi
fi

## Check DATA_PATH
if [ ! -d "$DATA_PATH" ]; then
        echo "No $DATA_PATH folder found"
        mkdir "$DATA_PATH"
        echo "Created $DATA_PATH folder"
fi

TODAY=$(date +%Y-%m-%d)

if [ $# -eq 0 ]; then
        $DEFAULT_EDITOR "$DATA_PATH/$TODAY.md"
else

        # Help -h
        if [ "$1" == "-h" ]; then
                # help
                echo "Usage: picojournal [date]"
                echo "If no date is supplied, today's journal will be opened."
                echo "If date is supplied, that journal will be opened."

                echo "Options:"
                echo "-h: help"
                echo "-v: version"
                echo "-e: export"
                echo "-i: insert line at top of file"
                echo "-a: append line at bottom of file"
                echo "-l: list all days"
                echo "Date format: YYYY-MM-DD"
                exit 0
        fi
        # Version -v
        if [ "$1" == "-v" ]; then
                # version
                echo "picojournal version 0.1"
                exit 0
        fi
        # Insert line at top of file -i
        if [ "$1" == "-i" ]; then

            if [ -z "$2" ]; then
                echo "No line supplied"
                echo "Usage: picojournal -i [date] LINE"
                exit 1
            fi
            # insert line at top of file
            # check if second argument is a date
            if [[ $2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                # second argument is a date
                # insert line at top of that file
                echo "Inserting line at top of $DATA_PATH/$2.md"
                echo "$3" | cat - "$DATA_PATH/$2.md" > temp && mv temp "$DATA_PATH/$2.md"
            else
                # second argument is not a date
                # insert line at top of today's file
                echo "Inserting line at top of $DATA_PATH/$TODAY.md"
                echo "$2" | cat - "$DATA_PATH/$TODAY.md" > temp && mv temp "$DATA_PATH/$TODAY.md"
            fi
            exit 0
        fi
        # Append line at bottom of file -a
        if [ "$1" == "-a" ]; then

            if [ -z "$2" ]; then
                echo "No line supplied"
                echo "Usage: picojournal -a [date] LINE"
                exit 1
            fi
            # append line at bottom of file
            # check if second argument is a date
            if [[ $2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                # second argument is a date
                # append line at bottom of that file
                echo "Appending line at bottom of $DATA_PATH/$2.md"
                echo "$3" >> "$DATA_PATH/$2.md"
            else
                # second argument is not a date
                # append line at bottom of today's file
                echo "Appending line at bottom of $DATA_PATH/$TODAY.md"
                echo "$2" >> "$DATA_PATH/$TODAY.md"
            fi
            exit 0
        fi
        # Export all variables as CSV -e
        if [ "$1" == "-e" ]; then
            VARIABLE=$2
            if [ -z "$VARIABLE" ]; then
                echo "No variable supplied"
                echo "Usage: picojournal -e VARIABLE"
                exit 1
            fi

            # check all files in data folder and find the variable values in each file
            for file in "$DATA_PATH"/*.md; do
                # variable is in format VARIABLE=90

                # check if variable is in file
                if grep -q "$VARIABLE" "$file"; then
                    # variable is in file
                    # get value
                    VALUE=$(grep "$VARIABLE" "$file" | cut -d "=" -f2)
                    # get date
                    DATE=$(echo "$file" | cut -d "/" -f5 | cut -d "." -f1)
                    # print date and value
                    echo "$DATE,$VALUE"
                fi

                exit 0
            done

            # export value to csv
            # TODO
            exit 0
        fi
        # List all days -l
        if [ "$1" == "-l" ]; then
            # cat all files in data folder
            for file in "$DATA_PATH"/*.md; do
                echo "$file"
                cat "$file"
                echo ""
            done
            exit 0
        fi

        if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                echo "$DEFAULT_EDITOR" "$DATA_PATH/$1.md"
        else
                echo "$DEFAULT_EDITOR" "$DATA_PATH/$TODAY.md"
        fi
fi