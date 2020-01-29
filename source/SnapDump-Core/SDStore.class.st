Class {
	#name : #SDStore,
	#superclass : #Object,
	#category : #'SnapDump-Core-Base'
}

{ #category : #accessing }
SDStore class >> mimeTypeFuel [

	^ 'application/X-SnapDump-Fuel'
]

{ #category : #accessing }
SDStore class >> mimeTypeStack [

	^ 'application/X-SnapDump-Stack'
]

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

	snapshot prepareExport.
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
