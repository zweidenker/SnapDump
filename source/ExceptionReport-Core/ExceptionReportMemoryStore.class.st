Class {
	#name : #ExceptionReportMemoryStore,
	#superclass : #ExceptionReportStore,
	#instVars : [
		'dict'
	],
	#category : 'ExceptionReport-Core'
}

{ #category : #accessing }
ExceptionReportMemoryStore class >> storeName [
	^ #memory
]

{ #category : #initialization }
ExceptionReportMemoryStore >> hasSnapshotNamed: aString [
	^ dict includesKey: aString
]

{ #category : #initialization }
ExceptionReportMemoryStore >> initialize [
	super initialize.
	dict := Dictionary new
]

{ #category : #'as yet unclassified' }
ExceptionReportMemoryStore >> snapshotNameFor: description [
	^ self persistedSnapshotNameOf: description
]

{ #category : #initialization }
ExceptionReportMemoryStore >> streamForName: aString do: aBlock [

	dict
		at: aString
		put: (ByteArray streamContents: [ :stream |
				aBlock value: stream ] )
]
