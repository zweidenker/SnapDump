"
I'm the base class of the snap file format. The structure of the format is

--- start of file ---
    4 bytes -- string SNAP. This is an early catch if a different format is provided
    1 byte  -- this contains the version number of the format. This is for future use
    4 bytes -- length [len] bytes of json meta-data
[len] bytes -- json meta-data
    4 bytes -- length [len] of textual stack trace
[len] bytes -- text textual stack trace
    4 bytes -- length [len] of fuel dump
[len] bytes -- text fuel dump
--- end of file ---
"
Class {
	#name : 'SDFileFormat',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'SnapDump-Core-Base',
	#package : 'SnapDump-Core',
	#tag : 'Base'
}

{ #category : 'accessing' }
SDFileFormat >> formatSignature [
	^ 'SNAP'
]

{ #category : 'accessing' }
SDFileFormat >> formatVersion [
	^ 2
]

{ #category : 'initialization' }
SDFileFormat >> initializeStream: aStream [

	stream := aStream 
]

{ #category : 'accessing' }
SDFileFormat >> stream [
	^ stream
]
