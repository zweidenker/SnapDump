Class {
	#name : #SDTests,
	#superclass : #TestCase,
	#instVars : [
		'rootPath',
		'snapDump'
	],
	#category : #'SnapDump-Core-Tests'
}

{ #category : #'as yet unclassified' }
SDTests >> createSimpleSnapshot [
	^ snapDump storeException: self snapshotMock.

]

{ #category : #'as yet unclassified' }
SDTests >> dummyContext [
	| context |
	context := (Context newForMethod: Object >> #printStringLimitedTo:).
	context
		initializeWith: 23 
		stackPtr: 1 
		method: Object >> #printStringLimitedTo: 
		receiver:  'TestString' 
		sender: ((Context newForMethod: Object >> #printString)
				initializeWith: 23 
				stackPtr: 1 
				method: Object >> #printString 
				receiver:  'TestString' 
				sender: ((Context newForMethod: Object >> #asString)
					initializeWith: 23 
					stackPtr: 1 
					method: Object >> #asString 
					receiver:  'TestString' 
					sender: nil)).
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
