Class {
	#name : #SDHTTPTests,
	#superclass : #SDTests,
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

{ #category : #'as yet unclassified' }
SDHTTPTests >> dummyContext [
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

{ #category : #tests }
SDHTTPTests >> snapshotMock [
	| mock |
	mock := Mock new. 
	mock stub asSnapshot willReturn: self dummyContext asSnapshot.
	^ mock

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
SDHTTPTests >> testProjectList [
	| response list |
	snapDump handleException: self snapshotMock.
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
SDHTTPTests >> testSetup [
	| mock |
	mock := self snapshotMock.
	self 
		shouldnt: [ snapDump handleException: mock ]
		raise: Error.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / mock asSnapshot id), #fuel) exists.

]

{ #category : #tests }
SDHTTPTests >> testSnapshotList [
	| response list |
	snapDump handleException: self snapshotMock.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject / #versions / '0.1' / #snapshots;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := (NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot .
	self assert: list size equals: 1.
	self assert: (list first signature) equals: 'FLPair_method1_SuddenlyAppearedContext'
	
]

{ #category : #tests }
SDHTTPTests >> testVersionList [
	| response list |
	snapDump handleException: self snapshotMock.
	response := ZnClient new
		url: self apiUri / #projects / #TestProject / #versions ;
		get;
		response.
	self assert: response isSuccess equals: true.
	list := NeoJSONReader fromString: response contents.
	self assert: list size equals: 1.
	self assert: (list first at: 'string') equals: '0.1'
	
]

{ #category : #tests }
SDHTTPTests >> zeroDivide [
	^ [ 1 / 0 ]
	on: Exception 
	do: [ :ex | snapDump handleException: ex ].
]
