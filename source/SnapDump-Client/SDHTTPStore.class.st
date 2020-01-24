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

{ #category : #accessing }
SDHTTPStore >> snapshotDumpFor: aSnapshot [ 
	^ self client
		headerAt: 'Accept' put: SDStore mimeTypeFuel;
		url: (self urlForSnapshot: aSnapshot);
		get
]

{ #category : #accessing }
SDHTTPStore >> snapshotStackFor: aSnapshot [ 

	^ (self client
		headerAt: 'Accept' put: SDStore mimeTypeStack;
		url: (self urlForSnapshot: aSnapshot);
		get) utf8Decoded
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
