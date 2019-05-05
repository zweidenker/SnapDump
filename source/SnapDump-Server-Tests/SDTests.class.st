Class {
	#name : #SDTests,
	#superclass : #TestCase,
	#instVars : [
		'rootPath',
		'snapDump'
	],
	#category : #'SnapDump-Server-Tests'
}

{ #category : #'as yet unclassified' }
SDTests >> createSimpleSnapshot [
	^ snapDump handleException: self snapshotMock.

]

{ #category : #'as yet unclassified' }
SDTests >> dummyContext [
	| context |
	context := (Context newForMethod: FLPair >> #method1).
	context
		initializeWith: 23 
		stackPtr: 1 
		method: FLPair >> #method1 
		receiver:  (FLPair new right: 4; left: 2) 
		sender: FLPair >> #method1.
	^ context
]

{ #category : #running }
SDTests >> filesystemStore [ 
	^ SDFilesystemStore new path: rootPath
]

{ #category : #running }
SDTests >> setUp [ 
	rootPath := FileSystem memory / #snaps.
	snapDump := SnapDump new store: self store. 
	snapDump 
		project: 'TestProject';
		version: '0.1'
]

{ #category : #tests }
SDTests >> snapshotMock [
	| mock |
	mock := Mock new. 
	mock stub asSnapshot willReturn: self dummyContext asSnapshot.
	^ mock

]

{ #category : #accessing }
SDTests >> store [
	self subclassResponsibility 
]
