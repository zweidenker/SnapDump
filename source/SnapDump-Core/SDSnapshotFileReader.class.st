Class {
	#name : #SDSnapshotFileReader,
	#superclass : #SDFileFormat,
	#instVars : [
		'snapshot',
		'position',
		'version'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'instance creation' }
SDSnapshotFileReader class >> file: aFileReference [
	
	^ self on: aFileReference binaryReadStream
]

{ #category : #'instance creation' }
SDSnapshotFileReader class >> on: aStream [
	
	^ self new initializeStream: aStream
]

{ #category : #accessing }
SDSnapshotFileReader >> file: aFileReference [ 
	
	snapshot file: aFileReference 
]

{ #category : #accessing }
SDSnapshotFileReader >> fuelDumpEntity [
	
	^ self fuelDumpStreamDo: [:str :length |
		ZnStreamingEntity 
			readFrom: str 
			usingType: (ZnMimeType main: 'application' sub: 'X-SnapDump-Fuel') 
			andLength: length ].
]

{ #category : #enumerating }
SDSnapshotFileReader >> fuelDumpStreamDo: aBlock [

	| length |
	self skipSection.
	self skipSection.
	length := self readLength.
	^ aBlock 
		value: (ZnLimitedReadStream on: stream limit: length)
		value: length.
]

{ #category : #accessing }
SDSnapshotFileReader >> initializeFromMeta [
	| length string |
	
	length := self readLength.
	string := (self read: length) utf8Decoded.
	string ifEmpty: [ ^ self ].
	snapshot := NeoJSONReader fromString: string as: SDFileSnapshot
]

{ #category : #accessing }
SDSnapshotFileReader >> initializeStream: aStream [
	
	| formatSignature |
	super initializeStream: aStream.
	
	position := 1.
	formatSignature := (self read: 4) asString.
	(formatSignature = self formatSignature) ifFalse: [ 
		Error signal: 'This is not a snapshot file' ].
	version := (self read: 1) asInteger.
	(version = self formatVersion) ifFalse: [ 
		Error signal: 'Cannot read version ', version asString, ' with reader version ', self formatVersion asString ].
	
]

{ #category : #'stream - reading' }
SDSnapshotFileReader >> read: anInteger [

	position := position + anInteger.
	^ stream next: anInteger 
]

{ #category : #'stream - reading' }
SDSnapshotFileReader >> readLength [

	^ (self read: 4) asInteger
]

{ #category : #'stream - reading' }
SDSnapshotFileReader >> skip: anInteger [ 
	
	stream skip: anInteger.
	position := position + anInteger 
]

{ #category : #'stream - reading' }
SDSnapshotFileReader >> skipSection [
	
	| length |
	length := self readLength.
	self skip: length
]

{ #category : #accessing }
SDSnapshotFileReader >> snapshot [
	^ snapshot
]

{ #category : #enumerating }
SDSnapshotFileReader >> stackTraceEntity [

	^ self stackTraceStreamDo: [:str :length |
		ZnStreamingEntity 
			readFrom: str 
			usingType: ZnMimeType textPlain 
			andLength: length ].
]

{ #category : #enumerating }
SDSnapshotFileReader >> stackTraceStreamDo: aBlock [
	
	| length |
	self skipSection.
	length := self readLength.
	^ aBlock 
		value: (ZnLimitedReadStream on: stream limit: length)
		value: length.
]
