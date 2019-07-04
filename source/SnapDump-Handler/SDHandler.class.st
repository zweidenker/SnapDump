Class {
	#name : #SDHandler,
	#superclass : #SnapDump,
	#instVars : [
		'project',
		'version'
	],
	#category : #'SnapDump-Handler'
}

{ #category : #accessing }
SDHandler class >> type [
	^ #handler
]

{ #category : #'as yet unclassified' }
SDHandler >> applyConfiguration: aConfig [
	super applyConfiguration: aConfig.
	self 
		projectName:  aConfig project
		versionString: aConfig version

]

{ #category : #accessing }
SDHandler >> defaultStoreClass [
	^ SDBasicHTTPStore 
]

{ #category : #'as yet unclassified' }
SDHandler >> handleException: exception [
	Transcript show: 'SnapDump: exception to report: ', exception description asString.
	^ [ self handleSnapshot: exception asSnapshot ]
		on: Error 
		do: [ :err | 
			"if we run inside a test case raise the error"
			CurrentExecutionEnvironment value isTest ifTrue: [ err pass ].
			"if an error occurrs while reporting an error there is nothing
			we can do"
			Transcript show: 'Error ', err description asString, ' happened while report error ', exception description asString.
			nil]

]

{ #category : #'as yet unclassified' }
SDHandler >> handleSnapshot: snapshot [
	self store isSetUp 
		ifTrue: [
			Transcript show: 'SnapDump: store is set up'.
			self store storeSnapshot: (snapshot 
				project: project;
				version: version ) ]
		ifFalse: [ Transcript show: 'tried to store snapshot but store is not set up'; cr ].
	^ snapshot 
]

{ #category : #accessing }
SDHandler >> project [
	^ project
]

{ #category : #accessing }
SDHandler >> project: anObject [
	project := anObject
]

{ #category : #'as yet unclassified' }
SDHandler >> projectName: projectName versionString: versionString [
	project := (SDProject name: projectName) store: store.
	version := (SDVersion string: versionString) project: project
]

{ #category : #accessing }
SDHandler >> version [
	^ version
]

{ #category : #accessing }
SDHandler >> version: anObject [
	version := anObject
]
