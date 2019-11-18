Class {
	#name : #SDStore,
	#superclass : #Object,
	#category : #'SnapDump-Core'
}

{ #category : #lookup }
SDStore class >> withName: aString [
	^ self subclasses detect: [ :each | each storeName = aString ]
]

{ #category : #accessing }
SDStore >> defaultSnapshotOccurrencesLimit [

	^ 10
	
	
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

{ #category : #testing }
SDStore >> shouldReportSnapshot: aSnapshot [
	self subclassResponsibility 
]

{ #category : #services }
SDStore >> storeSnapshot: snapshot [
	Transcript show: 'SnapDump: checking if error needs to be reported'.
	(self shouldReportSnapshot: snapshot)
		ifTrue: [ 
			Transcript show: 'SnapDump: error is being uploaded'.
			self writeSnapshot: snapshot.
	]
]

{ #category : #writing }
SDStore >> writeSnapshot: aSnapshot [
	self subclassResponsibility 
]
