Class {
	#name : #SDHTTPTests,
	#superclass : #SDServerTests,
	#instVars : [
		'port',
		'server'
	],
	#category : #'SnapDump-Server-Tests'
}

{ #category : #accessing }
SDHTTPTests >> apiUri [
	^ ('http://', self selfIP, ':', self randomPort asString, '/api') asZnUrl 
]

{ #category : #accessing }
SDHTTPTests >> apiVersionedUri [

	^ self apiUri / SDSnapshot apiVersion
]

{ #category : #accessing }
SDHTTPTests >> randomPort [
	^ port ifNil: [
		port := 27000 + 1000 atRandom ]
]

{ #category : #tests }
SDHTTPTests >> roundtripSnapshot [
	"create, store and retrieve snapshot to be able to test for a 
	fetched snapshot"
	| snapshot response |
	snapshot := self createSimpleSnapshot.
	response := ZnClient new
		url: (self urlForSnapshot: snapshot);
		get;
		response.
	self assert: response isSuccess.
	^ (NeoJSONReader on: response contents readStream) nextAs: SDSnapshot .
	
]

{ #category : #initialization }
SDHTTPTests >> selfIP [
	^ NetNameResolver stringFromAddress: (NetNameResolver addressForName: NetNameResolver localHostName)
]

{ #category : #running }
SDHTTPTests >> setUp [ 
	super setUp.
	server := SDServer new port: self randomPort; path: rootPath.
	server debugMode: true.
	server start.
	"SnapDump current stub store willReturn: store."
]

{ #category : #running }
SDHTTPTests >> store [ 
	^ SDHTTPStore new uri: self apiUri
]

{ #category : #tests }
SDHTTPTests >> tearDown [
	super tearDown.
	server stop.
]

{ #category : #tests }
SDHTTPTests >> testInternalServerError [
	| response snapshot |
	server znServer debugMode: false.
	response := ZnClient new
		url: (self urlForTestVersion / #exceptions / #foo / #snapshots / #bar);
		entity: (ZnByteArrayEntity bytes: '{bogus ;json' asByteArray);
		put;
		response.
	self assert: response isError.
	self deny: response code = 404.
	
	"there should  have been a snapshot generated on server side.
	this snapshot is expected to be consecutive to the parsing error"
	self assert: rootPath hasDirectories.
	snapshot := (SDSnapshotFileReader file: rootPath allFiles anyOne) snapshot.
	self assert: snapshot className equals: 'SDSnapshotFileReader'
]

{ #category : #tests }
SDHTTPTests >> testProject [
	| response project |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self urlForTestProject;
		get;
		response.
	self assert: response isSuccess.
	project := NeoJSONReader fromString: response contents.
	self assert: (project at: 'name') equals: 'TestProject'
	
]

{ #category : #tests }
SDHTTPTests >> testProjectList [
	| response list |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiVersionedUri / #projects;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := NeoJSONReader fromString: response contents.
	self assert: list size equals: 1.
	self assert: (list first at: 'name') equals: 'TestProject'
	
]

{ #category : #tests }
SDHTTPTests >> testProjectListEmpty [
	| response list |
	response := ZnClient new
		url: self apiVersionedUri / #projects;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := NeoJSONReader fromString: response contents.
	self assert: list isEmpty
]

{ #category : #tests }
SDHTTPTests >> testProjectNotFound [
	| response |
	response := ZnClient new
		url: self apiVersionedUri / #projects / 'NoneExisting';
		get;
		response.
	self assert: response status = 404.

]

{ #category : #tests }
SDHTTPTests >> testProjectRemove [
	| response |
	response := ZnClient new
		url: self apiVersionedUri / #projects / 'NoneExisting';
		delete;
		response.
	self assert: response status = 405.

]

{ #category : #tests }
SDHTTPTests >> testSetup [
	| mock root snapshot |
	mock := self snapshotMock.
	self 
		shouldnt: [ handler handleException: mock ]
		raise: Error.
	snapshot := mock asSnapshot.
	self assert: rootPath hasDirectories.
	root := self dummySnapshotRootPath / snapshot exceptionId.
	self assert: root hasFiles.
	self assert: ((root / mock asSnapshot snapshotId), #snap) exists.

]

{ #category : #tests }
SDHTTPTests >> testSnapshotDelete [
	| response snapshot |
	snapshot := self createSimpleSnapshot.
	response := ZnClient new
		url: (self urlForSnapshot: snapshot) ;
		delete;
		response.
	self assert: response isSuccess.

]

{ #category : #tests }
SDHTTPTests >> testSnapshotEmptyVersion [

	handler version: ('').
	"reporting empty version should not be allowed"
	self should: [self createSimpleSnapshot] raise: NotFound.
	

	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotGet [
	| response snapshot s |
	s := self createSimpleSnapshot.
	response := ZnClient new
		url: (self urlForSnapshot: s);
		get;
		response.
	self assert: response isSuccess.
	snapshot := (NeoJSONReader on: response contents readStream) nextAs: SDSnapshot .
	self assert: snapshot snapshotId equals: s snapshotId .
	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotGetContext [
	| snapshot context |
	snapshot := self roundtripSnapshot.
	context :=  FLMaterializer materializeFromByteArray: (self store snapshotDumpFor: snapshot).
	self assert: (context isKindOf: Context).
	self assert: context receiver = 'TestString'
]

{ #category : #tests }
SDHTTPTests >> testSnapshotGetStackTrace [
	| snapshot stackTrace |
	snapshot := self roundtripSnapshot.
	stackTrace :=  self store snapshotStackFor: snapshot.
	self assert: (stackTrace includesSubstring: 'ByteString(Object)>>printStringLimitedTo:
	Receiver: ''TestString'''

	)
]

{ #category : #tests }
SDHTTPTests >> testSnapshotList [
	| response list s |
	s := self createSimpleSnapshot.
	response := ZnClient new
		url: self apiVersionedUri / #projects / #TestProject / #versions / '0.1' / #exceptions / s exceptionId / #snapshots;
		get;
		response.
	self assert: response isSuccess.
	list := (NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot .
	self assert: list size equals: 1.
	self assert: (list first restoreModel; errorSignature) equals: 'TestProject_0.1_ContextWithoutException: Object>>#printStringLimitedTo:'
	
]

{ #category : #tests }
SDHTTPTests >> testSpec [
	| response |
	response := ZnClient new
		url: self apiVersionedUri / #spec;
		get;
		response.
	self assert: response isSuccess equals: true.
	self assert: (response entity string includesSubstring: 'SnapDump API')

	
]

{ #category : #tests }
SDHTTPTests >> testVersion [
	| response version |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiVersionedUri / #projects / #TestProject / #versions / #'0.1';
		get;
		response.
	self assert: response isSuccess equals: true.
	version := NeoJSONReader fromString: response contents.
	self assert: (version at: 'string') equals: '0.1'
	
]

{ #category : #tests }
SDHTTPTests >> testVersionList [
	| response list |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiVersionedUri / #projects / #TestProject / #versions ;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := NeoJSONReader fromString: response contents.
	self assert: list size equals: 1.
	self assert: (list first at: 'string') equals: '0.1'
	
]

{ #category : #tests }
SDHTTPTests >> urlForSnapshot: aSnapshot [
	^ (self urlForTestVersion / #exceptions / aSnapshot exceptionId / #snapshots / aSnapshot snapshotId)
]

{ #category : #tests }
SDHTTPTests >> urlForTestProject [ 
	^ self apiVersionedUri /#projects / self projectNameForTests 
]

{ #category : #tests }
SDHTTPTests >> urlForTestVersion [
	^ self urlForTestProject / #versions / self versionStringForTests
]
