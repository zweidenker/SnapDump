Class {
	#name : #SDFileSnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'bytes'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDFileSnapshot >> bytes [
	^ bytes
]

{ #category : #accessing }
SDFileSnapshot >> bytes: anObject [
	bytes := anObject
]

{ #category : #'as yet unclassified' }
SDFileSnapshot >> writeTo: stream [ 
	stream nextPutAll: bytes
]