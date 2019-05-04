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

{ #category : #accessing }
SDFileSnapshot >> file: aFileReference [ 
	baseFile := aFileReference 
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> writeTo: stream [ 
	stream nextPutAll: bytes
]
