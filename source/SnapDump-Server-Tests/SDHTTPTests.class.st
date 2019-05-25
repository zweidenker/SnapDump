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
		url: self apiUri / #snapshots / self dummySnapshotId;
		entity: (ZnStringEntity text: '{bogus ;json');
		put;
		response.
	self assert: response isError.
	self assert: rootPath hasFiles.
	snapshot := SDFileSnapshot fromFile: rootPath children anyOne.
	self assert: snapshot className equals: 'FLMaterializer'
]

{ #category : #tests }
SDHTTPTests >> testProject [
	| response project |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject;
		get;
		response.
	self assert: response isSuccess equals: true.
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
	| response list |
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
	| mock |
	mock := self snapshotMock.
	self 
		shouldnt: [ handler handleException: mock ]
		raise: Error.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / mock asSnapshot id), #snap) exists.

]

{ #category : #tests }
SDHTTPTests >> testSnapshot [
	| response snapshot |
	self createSimpleSnapshot.
	response := ZnClient new
		url: self apiUri / #snapshots / self dummySnapshotId;
		get;
		response.
	self assert: response isSuccess.
	snapshot := (NeoJSONReader on: response contents readStream) nextAs: SDSnapshot .
	self assert: snapshot id equals: self dummySnapshotId .
	
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
	self assert: (list first errorSignature) equals: 'Object_printString_ContextWithoutException'
	
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
