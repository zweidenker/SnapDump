Class {
	#name : #SDSnapshotFileReader,
	#superclass : #SDFileFormat,
	#instVars : [
		'snapshot',
		'position',
		'version'
	],
	#category : #'SnapDump-Core-Base'
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
		SDSnapshotFileFormatError signal: 'This is not a snapshot file: wrong signature' ].
	version := (self read: 1) asInteger.
	(version = self formatVersion) ifFalse: [ 
		SDSnapshotFileVersionError signal: 'Cannot read version ', version asString, ' with reader version ', self formatVersion asString ].
	
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
	"if the accessor is used we assume that someone needs a snapshot so initializing
	with content should be nice"
	snapshot ifNil: [ 
		self initializeFromMeta ].
	^ snapshot
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
