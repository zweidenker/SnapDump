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
SDCoreTests >> testProject [

	self createSimpleSnapshot.
	self 
		shouldnt: [ client projectNamed: 'TestProject' ifAbsent: [ nil ] ]
		raise: NotFound
]

{ #category : #tests }
SDCoreTests >> testProjectList [

	| projects |
	self createSimpleSnapshot.
	projects := client projects.
	self assert: projects size equals: 1.
	self assert: projects anyOne name equals: 'TestProject'

]

{ #category : #tests }
SDCoreTests >> testProjectListEmpty [

	self assert: client projects isEmpty.

]

{ #category : #tests }
SDCoreTests >> testProjectNotFound [

	self createSimpleSnapshot.
	self 
		should: [ client projectNamed: 'DoesNotExist' ]
		raise: NotFound
]

{ #category : #tests }
SDCoreTests >> testProjectRemove [

	| project |
	self createSimpleSnapshot.
	project := client projectNamed: 'TestProject'.
	self 
		shouldnt: [ project remove ]
		raise: Error
]

{ #category : #tests }
SDCoreTests >> testProjectVersion [

	| version |
	self createSimpleSnapshot.
	version := (client projectNamed: 'TestProject') versionAt: '0.1'.
	self assert: version string equals: '0.1'
]

{ #category : #tests }
SDCoreTests >> testProjectVersionNotFound [

	self createSimpleSnapshot.
	self 
		should: [ (client projectNamed: 'TestProject') versionAt: 'N/A' ]
		raise: NotFound.

]

{ #category : #tests }
SDCoreTests >> testProjectVersions [

	| versions |
	self createSimpleSnapshot.
	versions := (client projectNamed: 'TestProject') versions.
	self assert: versions size equals: 1
]

{ #category : #tests }
SDCoreTests >> testRemoveProjectVersion [

	| version project |
	self createSimpleSnapshot.
	project := client projectNamed: 'TestProject'.
	version := project versionAt: '0.1'.
	self 
		shouldnt: [ version remove ]
		raise: Error.
	self assert: project versions isEmpty 
	
]

{ #category : #tests }
SDCoreTests >> testRemoveSnapshot [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := client snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'.
	self 
		shouldnt: [ snapshot remove ]
		raise: Error.
	self assert: client projects isEmpty 
]

{ #category : #tests }
SDCoreTests >> testRemoveVersion [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := client snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'.
	snapshot version remove.
	self assert: client projects isEmpty 
]

{ #category : #tests }
SDCoreTests >> testSetup [
	| mock |
	mock := self snapshotMock.
	self 
		shouldnt: [ handler handleException: mock ]
		raise: Error.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / mock asSnapshot id), #snap) exists.

]

{ #category : #tests }
SDCoreTests >> testSnapshot [

	|  snapshot |
	self createSimpleSnapshot.
	snapshot := client snapshotWithId: self dummySnapshotId.
	self assert: snapshot className equals: 'Object'
]
