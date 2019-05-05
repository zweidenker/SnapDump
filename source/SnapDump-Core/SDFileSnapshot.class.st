Class {
	#name : #SDFileSnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'bytes',
		'baseFile'
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
SDFileSnapshot >> contents [
	^ (baseFile , #fuel) binaryReadStream contents 
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
