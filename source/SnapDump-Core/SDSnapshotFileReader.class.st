Class {
	#name : 'SDSnapshotFileReader',
	#superclass : 'SDFileFormat',
	#instVars : [
		'snapshot',
		'position',
		'version'
	],
	#category : 'SnapDump-Core-Base',
	#package : 'SnapDump-Core',
	#tag : 'Base'
}

{ #category : 'instance creation' }
SDSnapshotFileReader class >> file: aFileReference [
	
	^ self on: aFileReference binaryReadStream
]

{ #category : 'instance creation' }
SDSnapshotFileReader class >> on: aStream [
	
	^ self new initializeStream: aStream
]

{ #category : 'accessing' }
SDSnapshotFileReader >> context [
	^ FLMaterializer materializeFromByteArray: self fuelDump
]

{ #category : 'accessing' }
SDSnapshotFileReader >> file: aFileReference [ 
	
	snapshot file: aFileReference 
]

{ #category : 'enumerating' }
SDSnapshotFileReader >> fuelDump [

	^ self fuelDumpStreamDo: [ :str :lenght |
		str upToEnd ]
]

{ #category : 'enumerating' }
SDSnapshotFileReader >> fuelDumpStreamDo: aBlock [

	| length |
	"fuel dump is third section in the file so we skip two"
	self skipSection.
	self skipSection.
	length := self readLength.
	"construct a new limited stream to prevent somethig to read out of bounds"
	^ aBlock 
		value: (ZnLimitedReadStream on: stream limit: length)
		value: length.
]

{ #category : 'accessing' }
SDSnapshotFileReader >> initializeFromMeta [

	snapshot := NeoJSONReader 
		fromString: self metaDataString
		as: SDFileSnapshot
]

{ #category : 'accessing' }
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

{ #category : 'enumerating' }
SDSnapshotFileReader >> metaDataDictionary [

	^ NeoJSONReader fromString: self metaDataString 
]

{ #category : 'enumerating' }
SDSnapshotFileReader >> metaDataStreamDo: aBlock [

	| length |
	length := self readLength.
	"construct a new limited stream to prevent somethig to read out of bounds"
	^ aBlock 
		value: (ZnLimitedReadStream on: stream limit: length)
		value: length
]

{ #category : 'enumerating' }
SDSnapshotFileReader >> metaDataString [

	| string |
	string := (self metaDataStreamDo: [ :str :length |
		str upToEnd ]) utf8Decoded.
	string ifEmpty: [ 
		SDSnapshotFileFormatError signal: 'meta-data section is empty' ].
	^ string
]

{ #category : 'stream - reading' }
SDSnapshotFileReader >> read: anInteger [

	position := position + anInteger.
	^ stream next: anInteger 
]

{ #category : 'stream - reading' }
SDSnapshotFileReader >> readLength [

	"all lengths are fixed to 4 bytes giving 32 bit size of a section"
	^ (self read: 4) asInteger
]

{ #category : 'stream - reading' }
SDSnapshotFileReader >> skip: anInteger [ 
	
	"skip a number of bytes on a stream. This is a lot faster than reading the bytes to
	consume"
	stream skip: anInteger.
	position := position + anInteger 
]

{ #category : 'stream - reading' }
SDSnapshotFileReader >> skipSection [
	
	| length |
	length := self readLength.
	self skip: length
]

{ #category : 'accessing' }
SDSnapshotFileReader >> snapshot [
	"if the accessor is used we assume that someone needs a snapshot so initializing
	with content should be nice"
	snapshot ifNil: [ 
		self initializeFromMeta ].
	^ snapshot
]

{ #category : 'enumerating' }
SDSnapshotFileReader >> stackTrace [

	^ (self stackTraceStreamDo: [ :str :length |
		str upToEnd ]) utf8Decoded 

]

{ #category : 'enumerating' }
SDSnapshotFileReader >> stackTraceStreamDo: aBlock [
	
	| length |
	"textual stack trace is the second section so we have to skip one section"
	self skipSection.
	length := self readLength.
	"construct a new limited stream to prevent somethig to read out of bounds"
	^ aBlock 
		value: (ZnLimitedReadStream on: stream limit: length)
		value: length.
]
