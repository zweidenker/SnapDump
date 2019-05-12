Class {
	#name : #SDCoreTests,
	#superclass : #SDTests,
	#category : #'SnapDump-Core-Tests'
}

{ #category : #tests }
SDCoreTests >> dummySnapshotId [
	^ 'e93edf3a19e0214bbbee5ab1d0dae1336188a5ae928ee27611951a0e122e1340'
]

{ #category : #accessing }
SDCoreTests >> store [ 
	^ self filesystemStore
]

{ #category : #tests }
SDCoreTests >> testDeleteSnapshot [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := snapDump snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'.
	snapshot remove.
	self assert: snapDump projects isEmpty 
]

{ #category : #tests }
SDCoreTests >> testDeleteVersion [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := snapDump snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'.
	snapshot version remove.
	self assert: snapDump projects isEmpty 
]

{ #category : #tests }
SDCoreTests >> testProject [

	self createSimpleSnapshot.
	self 
		shouldnt: [ snapDump projectNamed: 'TestProject' ifAbsent: [ nil ] ]
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
	version := (snapDump projectNamed: 'TestProject') versionAt: '0.1'.
	self assert: version string equals: '0.1'
]

{ #category : #tests }
SDCoreTests >> testProjectVersionNotFound [

	self createSimpleSnapshot.
	self 
		should: [ (snapDump projectNamed: 'TestProject') versionAt: 'N/A' ]
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

{ #category : #tests }
SDCoreTests >> testSnapshot [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := snapDump snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'
]
