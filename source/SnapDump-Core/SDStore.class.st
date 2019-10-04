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
SDStore >> hasSnapshot: aString [
	self subclassResponsibility 
]

{ #category : #testing }
SDStore >> isSetUp [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDStore >> removeSnapshot: aSnapshot [ 
	
	(self snapshotPathFor: aSnapshot) delete.
	self reset

]

{ #category : #initialization }
SDStore >> reset [
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	Transcript show: 'SnapDump: checking if error needs to be reported'.
	(self hasSnapshot: snapshot)
		ifFalse: [ 
			Transcript show: 'SnapDump: error is being uploaded'.
			self writeSnapshot: snapshot.
			self reset ]
]

{ #category : #writing }
SDStore >> writeSnapshot: aSnapshot [
	self subclassResponsibility 
]
