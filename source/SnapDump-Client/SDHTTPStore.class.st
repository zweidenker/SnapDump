Class {
	#name : #SDHTTPStore,
	#superclass : #SDBasicHTTPStore,
	#category : #'SnapDump-Client'
}

{ #category : #accessing }
SDHTTPStore class >> storeName [
	^ #http
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> freeSlotsForException: anException [ 
	
		^ self freeSlotsForExceptionId: anException id project: anException projectName version: anException versionString
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> freeSlotsForExceptionId: anExceptionId project: aProjectName version: aVersionString [
	| response |
	
	response := self client
		url: uri / #projects / aProjectName / #versions / aVersionString / #exceptions / anExceptionId / #freeslots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) next)  ]
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString [
	^ self projectNamed: aString ifAbsent: [ NotFound signal: 'no project found' ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString ifAbsent: aBlock [
	| response |
	response := self client
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString ifAbsentPut: aBlock [
	| response |
	response := self client
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projects [
	| response |
	response := self client
		url: uri / #projects;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDProject) do: [ :p |
			p store: self ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> removeSnapshot: aSnapshot [ 
	| response |
	response := self client
		url: (self urlForSnapshot: aSnapshot);
		delete;
		response.
	response isSuccess 
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotDumpFor: aSnapshot [ 
	^ self client
		headerAt: 'Accept' put: 'application/X-SnapDump-Fuel';
		url: (self urlForSnapshot: aSnapshot);
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotWithId: aString project: aProjectName version: aVersionName exceptionId: anExceptionId [
	^ self client
		url: (self urlForSnapshot: aString project: aProjectName version: aVersionName exception: anExceptionId) / #snap;
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotsWithException: anException [ 
	| response |
	
	response := self client
		url: uri / #projects / anException projectName / #versions / anException versionString / #exceptions / anException / #snapshots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) do: [ :s |
			s exception: anException ] ]
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotsWithProject: projectName version: versionString [
	| response  |
	
	response := self client
		url: uri / #projects / projectName urlEncoded / #versions / versionString urlEncoded  / #snapshots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) ]
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotsWithVersion: aVersion [ 
	| response vs |
	vs := ZnResourceMetaUtils encodePercent: aVersion string safeSet: #urlPathSafeSet encoder: ZnCharacterEncoder utf8.
	response := self client
		url: uri / #projects / aVersion project name / #versions / vs / #snapshots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) do: [ :s |
			s version: aVersion ] ]
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> versionsOfProject: aProject [ 
	| response |
	response := self client
		url: uri / #projects / aProject name urlEncoded / #versions;
		get;
		response.
	response isSuccess 
		ifTrue: [  
			^ ((NeoJSONReader on: response contents readStream) nextListAs: SDVersion) do: [ :v |
				v project: aProject ] ]
		ifFalse: [ NotFound signal: (aProject name , ' project not found') ]
]
