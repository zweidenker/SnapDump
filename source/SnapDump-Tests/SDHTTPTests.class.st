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
	^ PrefixMappingDelegate new 
		map: 'api' 
		to: (ZnRestServerDelegate new
			uriSpace: (ZnCallHierarchyRestUriSpace new
				rootClass: SDCall))
]

{ #category : #accessing }
SDHTTPTests >> apiUri [
	^ 'http://', self selfIP, ':', self randomPort asString, '/api/' 
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
