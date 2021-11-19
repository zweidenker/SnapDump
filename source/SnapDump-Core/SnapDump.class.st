Class {
	#name : #SnapDump,
	#superclass : #Object,
	#instVars : [
		'store'
	],
	#classInstVars : [
		'current',
		'handler'
	],
	#category : #'SnapDump-Core-Base'
}

{ #category : #'as yet unclassified' }
SnapDump class >> applyConfiguration: aConfig [
	
	self setCurrent: (self withType: aConfig type) new.
	self current applyConfiguration: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<cinicStep>
	^ {  
		#section -> #SnapDump.
		#action -> [ :config |  
			
			self applyConfiguration: config ] }
]

{ #category : #accessing }
SnapDump class >> current [ 
	^ current ifNil: [ 
		current := self new ]
]

{ #category : #'as yet unclassified' }
SnapDump class >> hackUIManager [
	UIManager compile: 'logError: anError
		SnapDump current handleException: anError.
		super logError: anError'
]

{ #category : #accessing }
SnapDump class >> path: aPathString [
	^ self  
		store: (SDFilesystemStore new path: aPathString asFileReference);
		yourself 
]

{ #category : #initialization }
SnapDump class >> reset [
	current := nil 
]

{ #category : #'as yet unclassified' }
SnapDump class >> setCurrent: anObject [
	current := anObject 
]

{ #category : #accessing }
SnapDump class >> store [
	^ self current store
]

{ #category : #accessing }
SnapDump class >> store: aStore [
	self current store: aStore.
	handler ifNotNil: [ 
		handler store: aStore ]
]

{ #category : #'as yet unclassified' }
SnapDump class >> uri: aUri username: aUsername password: aPassword [
	^ self 
		store: (SDHTTPStore new 
			uri: aUri asZnUrl;
			username: aUsername password: aPassword);
		yourself 
]

{ #category : #accessing }
SnapDump class >> withType: aString [
	^ self allSubclasses detect: [ :each | each type = aString ]
]

{ #category : #initialization }
SnapDump >> applyConfiguration: aConfig [

	store := (SDStore withName: aConfig store) new.
	store applyConfiguration: aConfig
]

{ #category : #accessing }
SnapDump >> store [
	^ store ifNil: [ 
		Transcript show: 'SnapDump store is not set up. Ignoring exception sends!!!'; cr.
		^ nil ]
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
