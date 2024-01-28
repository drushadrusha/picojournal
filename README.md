<center>
<h1>🪴</h1>
</center>

Picojournal is a personal journal and database built unix way.

Work in progress, check out [TODO.md](TODO.md) to see which features are planned.

## installation

``` shell
curl [url to script] > pj
chmod +x pj
mv pj /usr/bin/
```

## usage

``` shell
# Open today file in editor
pj

# Append line to end of today file:
pj -a "some line i want to add"

# Insert line at top of 2024-01-02 file:
pj -i 2024-01-02 "some line i want to add"

# Export some_variable in CSV:
pj -e some_variable

# List all day files:
pj -l
```


## variables

Picojournal allow to have variables in your days.
To use them, you should put them as new line somewhere in your day file. For example:
```
Flower is looking good today! I took some measurments:

flower_lenght=10
soil_moisture=70

Would be interesting to check progress in a year!
```
After you could export it as CSV file using
``` shell
pj -e soil_moisture > soil_moisture.csv
```

## configuration

Configuration file is ```.picojournal``` in your home folder.

``` shell
# Your default editor path (will use nano or vi/vim by default)
DEFAULT_EDITOR=code
# Path to folder there picojournal will store all data
DATA_PATH=$HOME/.picojournal
```