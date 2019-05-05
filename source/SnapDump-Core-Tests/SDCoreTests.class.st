Class {
	#name : #SDCoreTests,
	#superclass : #SDTests,
	#category : #'SnapDump-Core-Tests'
}

{ #category : #accessing }
SDCoreTests >> store [ 
	^ self filesystemStore
]

{ #category : #tests }
SDCoreTests >> testNothing [
	self assert: true
]

{ #category : #tests }
SDCoreTests >> testProject [

	self createSimpleSnapshot.
	self 
		shouldnt: [ snapDump projectNamed: 'TestProject' ]
		raise: NotFound
]

{ #category : #tests }
SDCoreTests >> testProjectList [

	| projects |
	self createSimpleSnapshot.
	projects := snapDump projects.
	self assert: projects size equals: 1.
	self assert: projects anyOne name equals: 'TestProject'

]

{ #category : #tests }
SDCoreTests >> testProjectListEmpty [

	self assert: snapDump projects isEmpty.

]

{ #category : #tests }
SDCoreTests >> testProjectNotFound [

	self createSimpleSnapshot.
	self 
		should: [ snapDump projectNamed: 'DoesNotExist' ]
		raise: NotFound
]

{ #category : #tests }
SDCoreTests >> testProjectVersion [

	| version |
	self createSimpleSnapshot.
	version := (snapDump projectNamed: 'TestProject') versionWithString: '0.1'.
	self assert: version string equals: '0.1'
]

{ #category : #tests }
SDCoreTests >> testProjectVersionNotFound [

	self createSimpleSnapshot.
	self 
		should: [ (snapDump projectNamed: 'TestProject') versionWithString: 'N/A' ]
		raise: NotFound.

]

{ #category : #tests }
SDCoreTests >> testProjectVersions [

	| versions |
	self createSimpleSnapshot.
	versions := (snapDump projectNamed: 'TestProject') versions.
	self assert: versions size equals: 1
]

{ #category : #tests }
SDCoreTests >> testSetup [
	| mock |
	mock := self snapshotMock.
	self 
		shouldnt: [ snapDump storeException: mock ]
		raise: Error.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / mock asSnapshot id), #fuel) exists.

]
