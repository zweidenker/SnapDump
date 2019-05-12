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

{ #category : #'as yet unclassified' }
SDStore >> removeSnapshot: aSnapshot [ 
	
	^ self removeSnapshotWithId: aSnapshot id.

]

{ #category : #initialization }
SDStore >> reset [
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	(self hasSnapshotNamed: snapshot id)
		ifFalse: [ 
			self writeSnapshot: snapshot.
			self reset ]
]
