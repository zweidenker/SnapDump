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
SDStore >> hasSnapshot: aSnapshot [
	self subclassResponsibility 
]

{ #category : #testing }
SDStore >> isSetUp [
	self subclassResponsibility 
]

{ #category : #services }
SDStore >> removeSnapshot: aSnapshot [ 
	
	^ self subclassResponsibility 

]

{ #category : #initialization }
SDStore >> reset [
]

{ #category : #services }
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
