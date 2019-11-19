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
SDHTTPTests >> apiHandler [		
	^ ZnPrefixMappingDelegate new 
		map: 'api' 
		to: (SDServerDelegate new
			store: self filesystemStore;
			uriSpace: (OpenAPIUriSpace new
				rootClass: SDOpenAPICall))
]

{ #category : #accessing }
SDHTTPTests >> apiUri [
	^ ('http://', self selfIP, ':', self randomPort asString, '/api') asZnUrl 
]

{ #category : #tests }
SDHTTPTests >> dummySnapshotUrl [
	^ (self apiUri / #snapshots / self dummySnapshotId)
		queryAt: #exceptionId put: self dummyExceptionId;
		queryAt: 'projectName' put: self projectNameForTests;
		queryAt: 'versionName' put: self versionStringForTests;
		yourself
]

{ #category : #tests }
SDHTTPTests >> dummySnapshotUrlWithoutProject [
	^ self apiUri 
		/ #snapshots / self dummySnapshotId
		
	" #projects / self projectNameForTests / #versions
		/ self versionStringForTests / #exceptions / self dummyExceptionId"
]

{ #category : #accessing }
SDHTTPTests >> randomPort [
	^ port ifNil: [
		port := 27000 + 1000 atRandom ]
]

{ #category : #initialization }
SDHTTPTests >> selfIP [
	^ NetNameResolver stringFromAddress: (NetNameResolver addressForName: NetNameResolver localHostName)
]

{ #category : #running }
SDHTTPTests >> setUp [ 
	super setUp.
	server := (ZnServer on: self randomPort)
		delegate: self apiHandler;
		debugMode: true;
		start.
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
	server debugMode: false.
	response := ZnClient new
		url: self dummySnapshotUrl;
		entity: (ZnByteArrayEntity bytes: '{bogus ;json' asByteArray);
		put;
		response.
	self assert: response isError.
	self deny: response code = 404.
	self assert: rootPath hasDirectories.
	snapshot := SDFileSnapshot fromFile: rootPath allFiles anyOne.
	self assert: snapshot className equals: 'NeoJSONReader'
]

{ #category : #tests }
SDHTTPTests >> testProject [
	| response project |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject;
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
		url: self apiUri / #projects;
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
		url: self apiUri / #projects;
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
		url: self apiUri / #projects / 'NoneExisting';
		get;
		response.
	self assert: response status = 404.

]

{ #category : #tests }
SDHTTPTests >> testProjectRemove [
	| response |
	response := ZnClient new
		url: self apiUri / #projects / 'NoneExisting';
		delete;
		response.
	self assert: response status = 405.

]

{ #category : #tests }
SDHTTPTests >> testSetup [
	| mock root |
	mock := self snapshotMock.
	self 
		shouldnt: [ handler handleException: mock ]
		raise: Error.
	self assert: rootPath hasDirectories.
	root := self dummySnapshotRootPath.
	self assert: root hasFiles.
	self assert: ((root / mock asSnapshot snapshotId), #snap) exists.

]

{ #category : #tests }
SDHTTPTests >> testSnapshotEmptyVersion [
	| response  snap  |
	handler version: ('').
	snap := self createSimpleSnapshot.
	self assert: (snap isKindOf: SDMemorySnapshot).
	response := ZnClient new
		url: self apiUri
		/ #snapshots / self dummySnapshotId ;
		get;
		response.
	self deny: response isSuccess.
	self assert: response code = 404
	

	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotGet [
	| response snapshot |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self dummySnapshotUrl ;
		get;
		response.
	self assert: response isSuccess.
	snapshot := (NeoJSONReader on: response contents readStream) nextAs: SDSnapshot .
	self assert: snapshot snapshotId equals: self dummySnapshotId .
	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotGetById [
	| response snapshot |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self dummySnapshotUrlWithoutProject ;
		get;
		response.
	self assert: response isSuccess.
	snapshot := (NeoJSONReader on: response contents readStream) nextAs: SDSnapshot .
	self assert: snapshot snapshotId equals: self dummySnapshotId .
	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotList [
	| response list |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject / #versions / '0.1' / #snapshots;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := (NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot .
	self assert: list size equals: 1.
	self assert: (list first errorSignature) equals: 'TestProject_0.1_Object_printString_ContextWithoutException'
	
]

{ #category : #tests }
SDHTTPTests >> testSnapshotPutIdOnly [
	| response |
	server debugMode: false.
	response := ZnClient new
		url: self dummySnapshotUrlWithoutProject;
		entity: (ZnByteArrayEntity bytes: '{bogus ;json' asByteArray);
		put;
		response.
	self assert: response isError.
	self assert: response code = 400.
	self assert: (response entity string includesSubstring: 'MissingParameter').
	self deny: rootPath hasDirectories.
]

{ #category : #tests }
SDHTTPTests >> testVersion [
	| response version |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject / #versions / #'0.1';
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
		url: self apiUri / #projects / #TestProject / #versions ;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := NeoJSONReader fromString: response contents.
	self assert: list size equals: 1.
	self assert: (list first at: 'string') equals: '0.1'
	
]
