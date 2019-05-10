Class {
	#name : #SDStore,
	#superclass : #Object,
	#instVars : [
		'snapshots'
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

{ #category : #initialization }
SDStore >> reset [
	snapshots := nil.

]

{ #category : #accessing }
SDStore >> snapshots [
	^ snapshots ifNil: [
		snapshots := self buildSnapshots ]
		
]

{ #category : #'as yet unclassified' }
SDStore >> storeSnapshot: snapshot [
	(self hasSnapshotNamed: snapshot id)
		ifFalse: [ 
			self store: snapshot.
			self reset ]
]
