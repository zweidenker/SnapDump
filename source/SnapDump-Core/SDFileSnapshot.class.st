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
	^ (self readFrom: aFileReference binaryReadStream)
		file: aFileReference
]

{ #category : #accessing }
SDFileSnapshot class >> fromFile: aFileReference store: store [
	^ self new 
		store: store;
		file: aFileReference;
		readFrom: aFileReference binaryReadStream
	
]

{ #category : #accessing }
SDFileSnapshot class >> readFrom: aStream [
	^ self new
		setFuelHeader: (FLMaterializer new materializeHeaderFrom: aStream)
]

{ #category : #'as yet unclassified' }
SDFileSnapshot class >> readMetaFrom: stream [ 
	^ NeoJSONReader fromString: (stream upTo: self metaSeparator) utf8Decoded 

]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> contentStream [
	^ file binaryReadStream
		upTo: self class metaSeparator
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
SDFileSnapshot >> storeRaw: aByteArray [
	file binaryWriteStream 
		nextPutAll: aByteArray;
		close
]
