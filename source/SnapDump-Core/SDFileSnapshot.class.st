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

{ #category : #actions }
SDFileSnapshot >> fuelBytes [

	^ self contents
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> initializeMeta: dictionary [
	self basicMetaFields do: [ :field |
		self instVarNamed: field put: (dictionary at: field) ]
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> initializeMetaFromFile [

	self initializeMeta: (self class readMetaFrom: file asFileReference binaryReadStream)
]

{ #category : #'instance creation' }
SDFileSnapshot >> readFrom: aStream [
	^ self setFuelHeader: (FLMaterializer new materializeHeaderFrom: aStream)
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> setFuelHeader: aFLHeader [ 

	self basicMetaFields do: [ :field |
		self 
			instVarNamed: field 
			put: (aFLHeader additionalObjectAt: field) ].

]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> stackTraceStream [
	^ file binaryReadStream
		upTo: self class metaSeparator;
		upTo: self class metaSeparator;
		yourself
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> storeRaw: aByteArray [

	file binaryWriteStream 
		nextPutAll: aByteArray;  
		close
]
