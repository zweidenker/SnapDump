Class {
	#name : #SDTests,
	#superclass : #TestCase,
	#instVars : [
		'rootPath',
		'handler',
		'client'
	],
	#category : #'SnapDump-Core-Tests'
}

{ #category : #'as yet unclassified' }
SDTests >> createSimpleSnapshot [
	^ handler handleException: self snapshotMock.

]

{ #category : #'as yet unclassified' }
SDTests >> dummyContextSnapshot [
	
	| snapshot |
	snapshot := SDSnapshot dummyContextSnapshot.
	"snapshot exception instVarNamed: #id  put: self dummyExceptionId."
	snapshot		
		"instVarNamed: #exceptionId  put: self dummyExceptionId;"
		"instVarNamed: #snapshotId  put: self dummySnapshotId;"
		yourself.
	^ snapshot
]

{ #category : #tests }
SDTests >> dummyExceptionId [
	^ '292310505b9f7c1493d42c91693b6222e09f5ec6cd1e16d18d1b7ec1570d8a03'
]

{ #category : #tests }
SDTests >> dummySnapshotId [
	^ 'a946512aec0333fecaa26fbb58131ffec168e43b8f8e56999603005c94e39c92'
]

{ #category : #tests }
SDTests >> dummySnapshotRootPath [
	^ rootPath / self projectNameForTests / self versionStringForTests 
	
]

{ #category : #running }
SDTests >> filesystemStore [ 
	^ SDFilesystemStore new path: rootPath
]

{ #category : #running }
SDTests >> projectNameForTests [
	^ 'TestProject'
]

{ #category : #running }
SDTests >> setUp [
	| store |
	rootPath := #snaps asFileReference ensureCreateDirectory.
	store := self store.
	handler := SDHandler new store: store.
	client := SDClient new store: store.
	handler
		projectName: self projectNameForTests
		versionString: self versionStringForTests
]

{ #category : #tests }
SDTests >> snapshotMock [
	| mock |
	mock := Mock new. 
	mock stub asSnapshot  
		willReturn: self dummyContextSnapshot.
	^ mock

]

{ #category : #accessing }
SDTests >> store [
	self subclassResponsibility 
]

{ #category : #running }
SDTests >> tearDown [

	rootPath ensureDeleteAll
]

{ #category : #running }
SDTests >> versionStringForTests [
	^ '0.1'
]
