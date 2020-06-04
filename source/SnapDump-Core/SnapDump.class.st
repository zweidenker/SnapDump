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
	self beOfType: aConfig type.
	self current applyConfiguration: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump class >> beOfType: aSymbol [
	self deprecated: 'beOfType: is unnecessary now. Just remove calls to this method'
]

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<cinicStep>
	^ {  
		#section -> #SnapDump.
		#action -> [ :config |  self applyConfiguration: config ] }
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
	self current store: aStore
]

{ #category : #'as yet unclassified' }
SnapDump class >> uri: aUri username: aUsername password: aPassword [
	^ self 
		store: (SDHTTPStore new 
			uri: aUri asZnUrl;
			username: aUsername password: aPassword);
		yourself 
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
