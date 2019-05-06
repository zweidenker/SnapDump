Class {
	#name : #SDStore,
	#superclass : #Object,
	#instVars : [
		'nameStrategy'
	],
	#category : #'SnapDump-Core'
}

{ #category : #lookup }
SDStore class >> withName: aString [
	^ self subclasses detect: [ :each | each storeName = aString ]
]

{ #category : #testing }
SDStore >> hasSnapshotNamed: aString [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	(self hasSnapshotNamed: snapshot id)
		ifFalse: [ self store: snapshot ]
]
