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

	^ self handleSnapshot: exception asSnapshot

]

{ #category : #'as yet unclassified' }
SDHandler >> handleSnapshot: snapshot [
	self store isSetUp 
		ifTrue: [
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

{ #category : #'as yet unclassified' }
SDHandler >> projectName: projectName versionString: versionString [
	project := (SDProject name: projectName) store: store.
	version := (SDVersion string: versionString) project: project
]

{ #category : #accessing }
SDHandler >> version [
	^ version
]
