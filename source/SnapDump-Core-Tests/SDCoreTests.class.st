Class {
	#name : #SDCoreTests,
	#superclass : #SDTests,
	#category : #'SnapDump-Core-Tests'
}

{ #category : #tests }
SDCoreTests >> getDummySnapshotFromClient [
	| snap |
	snap := (client
		snapshotWithId: self dummySnapshotId project: self projectNameForTests version: self versionStringForTests) .
	^ snap
]

{ #category : #tests }
SDCoreTests >> getDummySnapshotFromClient: aString [
	| snap |
	snap := (client
		snapshotWithId: aString project: self projectNameForTests version: self versionStringForTests) .
	^ snap
]

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
SDCoreTests >> testReadSnapshotFuelDump [

	|  snapshot context fuel s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.	
	fuel := snapshot newReader fuelDumpStreamDo: [ :stream :length |
		stream upToEnd ].
	
	context := FLMaterializer materializeFromByteArray: fuel.
	self assert: context methodClass equals: Object
]

{ #category : #tests }
SDCoreTests >> testReadSnapshotMeta [

	|  snapshot s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.
	self assert: snapshot project name = 'TestProject'
]

{ #category : #tests }
SDCoreTests >> testReadSnapshotStackTrace [

	|  snapshot string stack s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.
	self assert: snapshot project name = 'TestProject'.
	
	stack := snapshot newReader stackTraceStreamDo: [ :stream :length |
		stream upToEnd ].
	
	string := stack utf8Decoded.
	self assert: (string includesSubstring: 'ByteString(Object)>>printStringLimitedTo:')	
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

	|  snapshot s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.
	self assert: snapshot className equals: 'Object'.
	self 
		shouldnt: [ snapshot remove ]
		raise: Error.
	self assert: client projects isEmpty 
]

{ #category : #tests }
SDCoreTests >> testRemoveVersion [
	| snapshot s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.
	self assert: snapshot className equals: 'Object'.
	snapshot version remove.
	self assert: client projects isEmpty
]

{ #category : #tests }
SDCoreTests >> testSetup [
	| mock root snapshot |
	mock := self snapshotMock.
	self 
		shouldnt: [ handler handleException: mock ]
		raise: Error.
	"only directories should be contained by the root path"
	self deny: rootPath hasFiles.
	self assert: rootPath hasDirectories.
	snapshot := mock asSnapshot.
	root := self dummySnapshotRootPath / snapshot exceptionId.
	self assert: root exists. 
	self assert: root isDirectory. 
	self assert: ((root / mock asSnapshot snapshotId), #snap) exists.

]

{ #category : #tests }
SDCoreTests >> testSnapshot [

	|  snapshot s |
	s := self createSimpleSnapshot.
	snapshot := self getDummySnapshotFromClient: s snapshotId.
	self assert: snapshot className equals: 'Object'
]

{ #category : #tests }
SDCoreTests >> testWriteAndRead [
	| snapshot file   meta context stack |
	snapshot := self createSimpleSnapshot.
	file := 'snapshot-writer-test.snap' asFileReference.
	[ 
	(SDSnapshotFileWriter file: file) writeSnapshot: snapshot.
	
	meta := (SDSnapshotFileReader file: file) metaDataDictionary.
	self assert: (meta at: #versionString) equals: self versionStringForTests. 
	self assert: (meta at: #projectName) equals: self projectNameForTests. 
	
	context := (SDSnapshotFileReader file: file) context.
	self assert: (context isKindOf: Context). 
	self assert: context receiver equals: 'TestString'.
	
	stack := (SDSnapshotFileReader file: file) stackTrace.
	self assert: (stack  includesSubstring: 'ByteString(Object)>>printStringLimitedTo:'). 
	self assert: (stack trim endsWith: 'ByteString(Object)>>asString') ]
		ensure: [ file ensureDelete ]
]
