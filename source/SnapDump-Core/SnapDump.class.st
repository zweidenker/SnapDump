Class {
	#name : #SnapDump,
	#superclass : #Object,
	#instVars : [
		'store'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'as yet unclassified' }
SnapDump class >> applyConfiguration: aConfig [
	self beOfType: aConfig type.
	self current applyConfiguration: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump class >> beOfType: aSymbol [
	current := (self withType: aSymbol) new
]

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<configurationStep>
	^ {  
		#group -> #SnapDump.
		#action -> [ :config |  self applyConfiguration: config ] }
]

{ #category : #accessing }
SnapDump class >> current [ 
	^ current ifNil: [ 
		current := SDHandler new ]
]

{ #category : #'as yet unclassified' }
SnapDump class >> hackUIManager [
	UIManager compile: 'logError: anError
		SnapDump current handleException: anError.
		super logError: anError'
]

{ #category : #public }
SnapDump class >> handleException: exception [
	^ self current handleException: exception 
]

{ #category : #'as yet unclassified' }
SnapDump class >> handleSnapshot: aSnapshot [ 
	^ self current handleSnapshot: aSnapshot 
]

{ #category : #accessing }
SnapDump class >> path: aPathString [
	^ self current 
		store: (SDFilesystemStore new path: aPathString asFileReference);
		yourself 
]

{ #category : #initialization }
SnapDump class >> reset [
	current := nil 
]

{ #category : #'as yet unclassified' }
SnapDump class >> uri: aUri username: aUsername password: aPassword [
	^ self current store 
			uri: aUri asZnUrl;
			username: aUsername password: aPassword
]

{ #category : #'accessing structure variables' }
SnapDump class >> withType: aSymbol [
	^ self allSubclasses detect: [ :each | each type = aSymbol ]
]

{ #category : #initialization }
SnapDump >> applyConfiguration: aConfig [
	store := (SDStore withName: aConfig store) new.
	store applyConfiguration: aConfig
]

{ #category : #accessing }
SnapDump >> defaultStoreClass [
	self subclassResponsibility 
]

{ #category : #accessing }
SnapDump >> store [
	^ store ifNil: [ 
		store := self defaultStoreClass new ]
]

{ #category : #accessing }
SnapDump >> store: anObject [
	store := anObject 
]

{ #category : #initialization }
SnapDump >> uri: aUri username: aUsername password: aPassword [
	^ self store 
			uri: aUri asZnUrl;
			username: aUsername password: aPassword
]
