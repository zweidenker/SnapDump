Class {
	#name : #SDHandler,
	#superclass : #SnapDump,
	#instVars : [
		'project',
		'version',
		'emergencyHandler'
	],
	#category : #'SnapDump-Handler'
}

{ #category : #'as yet unclassified' }
SDHandler class >> fillExamples [
	| handler |
	handler := SDHandler new
		store: SnapDump current store.

1 to: 2 do: [:x| | snapshot |
	1 to: 2 do: [ :y |
		1 to: 2 do: [ :z |  
	handler 
		projectName: ('projectname', x asString) 
		versionString: '1.', y asString.
	snapshot := SDSnapshot dummyContextSnapshot.
	handler handleSnapshot: snapshot ] ] ]
]

{ #category : #accessing }
SDHandler class >> type [
	^ #handler
]

{ #category : #setup }
SDHandler >> applyConfiguration: aConfig [
	super applyConfiguration: aConfig.
	self 
		projectName:  aConfig project
		versionString: aConfig version

]

{ #category : #accessing }
SDHandler >> defaultEmergencyHandler [
	^ [ :emergency :exception | 
		Transcript show: 'Error ', emergency description asString, ' happened while report error ', exception description asString.
		nil ].
]

{ #category : #accessing }
SDHandler >> emergencyHandler [

	^ emergencyHandler ifNil: [ 
		emergencyHandler := self defaultEmergencyHandler ]
]

{ #category : #accessing }
SDHandler >> emergencyHandler: anObject [

	emergencyHandler := anObject
]

{ #category : #services }
SDHandler >> handleException: exception [
	Transcript show: 'SnapDump: exception to report: ', exception description asString; cr.
	store ifNil: [ 
		Transcript show: 'SnapDump store is not set up. Ignoring exception sends!!!'; cr.
		^ nil ].
	^ [ self handleSnapshot: exception asSnapshot ]
		on: Error 
		do: [ :emergency | 
			"if we run inside a test case raise the error"
			CurrentExecutionEnvironment value isTest ifTrue: [ emergency pass ].
			"if an error occurrs while reporting an error we call the 
			emergeny handler with the original exception and "
			self emergencyHandler
				value: emergency 
				value: exception ]

]

{ #category : #services }
SDHandler >> handleSnapshot: snapshot [
	self store isSetUp
		ifTrue: [ Transcript show: 'SnapDump: store is set up'.
			self store
				storeSnapshot:
					(snapshot
						versionString: self version;
						projectName: self project;
						yourself) ]
		ifFalse: [ Transcript
				show: 'tried to store snapshot but store is not set up';
				cr ].
	^ snapshot
]

{ #category : #accessing }
SDHandler >> project [
	^ project ifNil: [ 'NoProject' ]
]

{ #category : #accessing }
SDHandler >> project: anObject [
	project := anObject
]

{ #category : #accessing }
SDHandler >> projectName: projectName versionString: versionString [
	self project: projectName.
	self version: versionString
]

{ #category : #accessing }
SDHandler >> version [
	^ version ifNil: [ 'noVersion' ]
]

{ #category : #accessing }
SDHandler >> version: anObject [
	version := anObject
]
