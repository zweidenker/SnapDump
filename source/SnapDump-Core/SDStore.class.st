Class {
	#name : #SDStore,
	#superclass : #Object,
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

{ #category : #testing }
SDStore >> isSetUp [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDStore >> removeSnapshot: aSnapshot [ 
	
	^ self removeSnapshotWithId: aSnapshot id.

]

{ #category : #initialization }
SDStore >> reset [
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	Transcript show: 'SnapDump: checking if error needs to be reported'.
	(self hasSnapshotNamed: snapshot id)
		ifFalse: [ 
			Transcript show: 'SnapDump: error is being uploaded'.
			self writeSnapshot: snapshot.
			self reset ]
]

{ #category : #writing }
SDStore >> writeSnapshot: aSnapshot [
	self subclassResponsibility 
]
