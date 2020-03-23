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
	
	^ SDSnapshot dummyContextSnapshot.

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
	"| mock |
	mock := Mock new. 
	mock stub asSnapshot  
		willReturn: self dummyContextSnapshot.
	^ mock"
	^ ExceptionMock snapshot: self dummyContextSnapshot 

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
