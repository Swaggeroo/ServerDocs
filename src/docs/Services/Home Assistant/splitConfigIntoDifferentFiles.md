# Splitting config into multiple files
In HA it is possible to split the configuration into multiple files. This can be useful to keep the configuration clean and organized. The  configuration.yaml file can be split into multiple files by using the `!include` directive. I really recommend to use a separate file for sensors at least. This makes your configuration much cleaner and easier to maintain if you have a lot of sensors.
## Example
```yaml
# configuration.yaml
sensor: !include sensors.yaml
```

```yaml
# sensors.yaml
- platform: template
  sensors:
    my_first_sensor:
# ...
```