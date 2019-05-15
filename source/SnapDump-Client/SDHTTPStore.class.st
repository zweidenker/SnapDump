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
		url: uri / #snapshots / aSnapshot id;
		delete;
		response.
	response isSuccess 
		ifFalse: [ NotFound signal ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotDumpWithId: aString [ 
	^ self client
		headerAt: 'Accept' put: 'application/X-SnapDump-Fuel';
		url: uri / #snapshots / aString;
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotWithId: aString [ 
	^ self client
		url: uri / #snapshots / aString / #fuel;
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotsWithVersion: aVersion [ 
	| response |
	response := self client
		url: uri / #projects / aVersion project name / #versions / aVersion string / #snapshots;
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
		url: uri / #projects / aProject name / #versions;
		get;
		response.
	response isSuccess 
		ifTrue: [  
			^ ((NeoJSONReader on: response contents readStream) nextListAs: SDVersion) do: [ :v |
				v project: aProject ] ]
		ifFalse: [ NotFound signal ]
]
