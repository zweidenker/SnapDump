Class {
	#name : #SDFileSnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'file'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFileSnapshot class >> fromFile: aFileReference [
	^ (self readFrom: aFileReference asFileReference binaryReadStream)
		file: aFileReference asFileReference 
]

{ #category : #accessing }
SDFileSnapshot class >> readFrom: aStream [
	^ self new 
		initializeMeta: (self readMetaFrom: aStream)
]

{ #category : #'as yet unclassified' }
SDFileSnapshot class >> readMetaFrom: stream [ 
	^ NeoJSONReader fromString: (stream upTo: self metaSeparator) utf8Decoded 

]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> contentStream [
	^ file binaryReadStream
		upTo: self class metaSeparator;
		yourself
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> contents [
	^ self contentStream contents 
]

{ #category : #accessing }
SDFileSnapshot >> file: aFileReference [ 
	file := aFileReference 
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> fileSize [
	^ file size
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> initializeMeta: dictionary [
	self basicMetaFields do: [ :field |
		self instVarNamed: field put: (dictionary at: field) ]
]

{ #category : #actions }
SDFileSnapshot >> openDebugger [ 
	FLMaterializer materializeFromByteArray: self contents
]

{ #category : #'instance creation' }
SDFileSnapshot >> readFrom: aStream [
	^ self setFuelHeader: (FLMaterializer new materializeHeaderFrom: aStream)
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> sanitize [
	"prevent project or version to be nil. If there is an error reported without
	those fields it is better to store it with a default name so it can be seen
	that the setup is wrong"
	(project isNil or: [ project name isEmpty ]) ifTrue: [ 
		project := SDProject name: 'unknown' ].
	(version isNil or: [ version string isEmpty ]) ifTrue: [ 
		version := (SDVersion string: 'unknown') project: project ]
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> setFuelHeader: aFLHeader [ 

	self basicMetaFields do: [ :field |
		self 
			instVarNamed: field 
			put: (aFLHeader additionalObjectAt: field) ].

]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> storeRaw: aByteArray [
	"write file with new json header in case the fields have been changed"
	file binaryWriteStream 
		nextPutAll: (NeoJSONWriter toString: self) utf8Encoded;  
		nextPut: self class metaSeparator;
		nextPutAll: (aByteArray copyFrom: ((aByteArray indexOf: self class metaSeparator) + 1) to: aByteArray size );
		close
]
