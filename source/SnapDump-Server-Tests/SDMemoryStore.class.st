Class {
	#name : #SDMemoryStore,
	#superclass : #SDStore,
	#instVars : [
		'dict'
	],
	#category : #'SnapDump-Server-Tests'
}

{ #category : #accessing }
SDMemoryStore class >> storeName [
	^ #memory
]

{ #category : #initialization }
SDMemoryStore >> hasSnapshotNamed: aString [
	^ dict includesKey: aString
]

{ #category : #initialization }
SDMemoryStore >> initialize [
	super initialize.
	dict := Dictionary new
]

{ #category : #'as yet unclassified' }
SDMemoryStore >> snapshotNameFor: description [
	^ self persistedSnapshotNameOf: description
]

{ #category : #initialization }
SDMemoryStore >> streamForName: aString do: aBlock [

	dict
		at: aString
		put: (ByteArray streamContents: [ :stream |
				aBlock value: stream ] )
]
