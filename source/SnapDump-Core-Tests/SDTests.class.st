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

{ #category : #tests }
SDTests >> dummySnapshotId [
	^ '292310505b9f7c1493d42c91693b6222e09f5ec6cd1e16d18d1b7ec1570d8a03'
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
		projectName: 'TestProject'
		versionString: '0.1'
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
