Class {
	#name : #SDFileSnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'bytes',
		'baseFile',
		'file'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFileSnapshot class >> file: aFileReference [
	^ ((NeoJSONReader on: (aFileReference, #json) readStream) 
		nextAs: self)
			file: aFileReference 
]

{ #category : #accessing }
SDFileSnapshot class >> fromBytes: aByteArray [
	^ self new setBytes: aByteArray
		
]

{ #category : #accessing }
SDFileSnapshot class >> fuel: aFileReference [
	^ (self readFrom: aFileReference binaryReadStream)
		file: aFileReference
]

{ #category : #accessing }
SDFileSnapshot class >> readFrom: aStream [
	^ self new
		setFuelHeader: (FLMaterializer new materializeHeaderFrom: aStream)
]

{ #category : #accessing }
SDFileSnapshot >> bytes [
	^ bytes
]

{ #category : #accessing }
SDFileSnapshot >> bytes: anObject [
	bytes := anObject
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> contentStream [
	^ file binaryReadStream
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

{ #category : #initialization }
SDFileSnapshot >> setBytes: aByteArray [
	bytes := aByteArray.
	self setFuelHeader: (FLMaterializer new materializeHeaderFrom: aByteArray readStream)
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> setFuelHeader: aFLHeader [ 
	self metaFields do: [ :field |
		self instVarNamed: field put: (aFLHeader additionalObjectAt: field) ]
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> writeTo: stream [ 
	stream nextPutAll: bytes
]
