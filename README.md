SnapDump
========

[![Build Status](https://travis-ci.com/zweidenker/SnapDump.svg?branch=master)](https://travis-ci.com/zweidenker/SnapDump)

SnapDump is a software for pharo to create and manage runtime snapshots. When developing software in pharo and an exception occurs we get a debugger window openend. This is not possible if the application is deployed in a server environment. Usually activity of a server is written in logfiles but logfiles are a very poor way of getting error feedback from your application. In pharo we can snapshot the state of the application when an exception occurs. This snapshot can be serialized using the fuel graph serializer and uploaded to a server. By uploading the snapshot to a server we can use SnapDump in a distributed scenario where multiple servers give feedback.

Quick start
-----------

SnapDump is available as docker application for easy deployment. To keep the snapshots on server restart we need to create a volume where snapshots can be stored. You do this by invoking 

    $ docker volume create SnapDump

SnapDump uses internally the port 5555 for the server. This can be mapped to a local port on the host by specifying on the docker commandline. To start the server with that port and the former created volume invoke

    $ docker run -p 8888:5555 -v SnapDump:/snapshots zweidenker/snap-dump

Download a pharo image and install the SnapDump client

    $ curl get.pharo.org/64/70+vm | bash
    $ ./pharo-ui Pharo.image

To install SnapDump open a playground and execute

    Metacello new
	    repository: 'github://zweidenker/SnapDump';
	    baseline: #SnapDump;
	    load

To configure and open the UI client execute

    "configure the SnapDump client to access the docker container"
    SnapDump uri: 'http://localhost:8888/api'.
    "Uploaded a few snapshots to see something in the client"
    SDHandler fillExamples.
    "open the ui"
    SnapDump ui

 You should see this

 ![SnapDump UI](https://raw.githubusercontent.com/zweidenker/SnapDump/master/images/ui.png)

Selecting a snapshot gives detailled information about the snapshot. Pressing the "Open Snapshot" button will open a debugger with that snapshot.
