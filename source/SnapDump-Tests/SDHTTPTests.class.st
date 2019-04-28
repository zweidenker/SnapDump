Class {
	#name : #SDHTTPTests,
	#superclass : #SDTests,
	#instVars : [
		'port',
		'server'
	],
	#category : #'SnapDump-Tests'
}

{ #category : #accessing }
SDHTTPTests >> apiHandler [		
	^ ZnPrefixMappingDelegate new 
		map: 'api' 
		to: (SDServerDelegate new
			store: self filesystemStore;
			uriSpace: (ZnCallHierarchyRestUriSpace new
				rootClass: SDCall))
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
	self assert: list notEmpty
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
	| snapshot |
	snapshot := self zeroDivide.
	self assert: rootPath hasFiles.
	self assert: ((rootPath / snapshot id), #fuel) exists.

]

{ #category : #tests }
SDHTTPTests >> zeroDivide [
	^ [ 1 / 0 ]
	on: Exception 
	do: [ :ex | snapDump handleException: ex ].
]
