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
SDFileSnapshot class >> fuel: aFileReference [
	^ self new
		file: aFileReference; 
		setFuelHeader: (FLMaterializer new materializeHeaderFrom: aFileReference binaryReadStream)
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

{ #category : #'as yet unclassified' }
SDFileSnapshot >> setFuelHeader: aFLHeader [ 
	self metaFields do: [ :field |
		self instVarNamed: field put: (aFLHeader additionalObjectAt: field) ]
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> writeTo: stream [ 
	stream nextPutAll: bytes
]
