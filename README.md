# Esensors Websensor Application Monitor Template for Solarwinds SAM (Server & Application Monitor)

## Template Installation
* Save `Esensors Websensor.apm-template` to your computer
* Open Orion Web Console
* In the main menu open `SETTINGS -> All Settings`
* In the `PRODUCT SPECIFIC SETTINGS` section follow `SAM Settings` link
* In the `APPLICATION MONITOR TEMPLATES` section follow `Manage Templates` link
* Click `IMPORT/EXPORT` button and choose `Esensors Websensor.apm-template`
  which you saved at the first step

After the actions above you should see `Esensors Websensor` template
on the `APPLICATION MONITOR TEMPLATES`

## Creating Websensor device
* In the main menu open `SETTINGS -> Manage Nodes`
* Choose `ADD NODE` button
* Specify node IP address
* Choose either `External Node` or `Status Only: ICMP` (if your firewall
  is configured to allow ICMP to the device)
* Choose `NEXT` button
* On the `Add Application monitors` screen find in the `Show only` dropdown
  `Esensors Websensor` which filters the list
* Mark `Esensors Websensor` and `Inherit credentials from template` checkboxes
* Choose `NEXT` button
* Configure `Polling` session as appropriate (defaults work fine on a one node
  SAM installation)
* Choose `OK, ADD NODE` button

## Configuring port and url and monitoring thresholds
Template works with default tcp port `80` and url `status.xml`, if your device
is configured to use other port and/or url, you'll have to redefine them
for the specific node (such as the one, created at the previos step).

To reconfigure either port or url:
* In the main menu open `SETTINGS -> All Settings`
* In the `All applications` widget
* In the `PRODUCT SPECIFIC SETTINGS` section follow `SAM Settings` link
* In the `APPLICATION MONITORS` section follow `Manage Application Monitors` link
* Choose `Esensors Websensor` on your device and click `EDIT PROPERTIES` button
* Expand `All sensors` in the `Component Monitors` section (click plus sign)
* Find `Script Arguments:` field and choose `OVERRIDE TEMPLATE` button
* Set desired values
* Choose `SUBMIT` button

On this same screen you can set monitoring thresholds.
