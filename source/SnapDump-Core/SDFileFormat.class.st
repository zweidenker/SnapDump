Class {
	#name : #SDFileFormat,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SnapDump-Core-Base'
}

{ #category : #accessing }
SDFileFormat >> formatSignature [
	^ 'SNAP'
]

{ #category : #accessing }
SDFileFormat >> formatVersion [
	^ 2
]

{ #category : #initialization }
SDFileFormat >> initializeStream: aStream [

	stream := aStream 
]

{ #category : #accessing }
SDFileFormat >> stream [
	^ stream
]
