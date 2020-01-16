Class {
	#name : #SDHTTPStore,
	#superclass : #SDBasicHTTPStore,
	#category : #'SnapDump-Client'
}

{ #category : #accessing }
SDHTTPStore class >> storeName [
	^ #http
]

{ #category : #'services - getting' }
SDHTTPStore >> exceptionsOfVersion: aVersion [ 
	| response |
	response := self client
		url: uri / #projects / aVersion projectName urlEncoded / #versions / aVersion string / #exceptions;
		get;
		response.
	response isSuccess 
		ifTrue: [  
			^ ((NeoJSONReader on: response contents readStream) nextListAs: SDException) do: [ :e |
				e version: aVersion ] ]
		ifFalse: [ NotFound signal: ('Version' , aVersion printString , ' for project ', aVersion projectName printString, ' not found') ]
]

{ #category : #'services - getting' }
SDHTTPStore >> freeSlotsForException: anException [ 
	
		^ self freeSlotsForExceptionId: anException id project: anException projectName version: anException versionString
]

{ #category : #'services - getting' }
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

{ #category : #'services - testing' }
SDHTTPStore >> hasSnapshot: snapshot [
	^ (self client
		url: (self urlForSnapshot: snapshot);
		head;
		response) status = 200
]

{ #category : #accessing }
SDHTTPStore >> projectNamed: aString [
	^ self projectNamed: aString ifAbsent: [ NotFound signal: 'no project found' ]
]

{ #category : #accessing }
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

{ #category : #accessing }
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

{ #category : #accessing }
SDHTTPStore >> projects [
	| response |
	response := self client
		url: uri / #projects;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDProject) do: [ :p |
			p store: self ]
]

{ #category : #'services - removing' }
SDHTTPStore >> removeSnapshot: aSnapshot [ 
	| response |
	response := self client
		url: (self urlForSnapshot: aSnapshot);
		delete;
		response.
	response isSuccess 
		ifFalse: [ NotFound signal ]
]

{ #category : #'services - testing' }
SDHTTPStore >> shouldReportSnapshot: snapshot [
	^ (self hasSnapshot: snapshot) not
		and: [ (self
				freeSlotsForException: snapshot exception) > 0 ]
]

{ #category : #accessing }
SDHTTPStore >> snapshotDumpFor: aSnapshot [ 
	^ self client
		headerAt: 'Accept' put: 'application/X-SnapDump-Fuel';
		url: (self urlForSnapshot: aSnapshot);
		get
]

{ #category : #'services - getting' }
SDHTTPStore >> snapshotsOfException: anException [ 
	| response |
	
	response := self client
		url: uri / #projects / anException projectName / #versions / anException versionString / #exceptions / anException id / #snapshots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) do: [ :s |
			s exception: anException ] ]
		ifFalse: [ NotFound signal ]
]

{ #category : #'services - getting' }
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
