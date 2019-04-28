Class {
	#name : #SnapDump,
	#superclass : #Object,
	#instVars : [
		'store'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SnapDump-Client'
}

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<configurationStep>
	^ {  
		#group -> #SnapDump.
		#action -> [ :config | SnapDump current applyConfig: config ] }
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

{ #category : #public }
SnapDump class >> handleException: exception [
	^ self current handleException: exception 
]

{ #category : #'as yet unclassified' }
SnapDump >> applyConfig: aConfig [
	store := (SDStore withName: aConfig store) new.
	store applyConfig: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump >> handleException: exception [
	| snapshot |
	snapshot := exception asSnapshot.
	self store ifNotNil: [
		self store storeSnapshot: snapshot ].
	^ snapshot
]

{ #category : #accessing }
SnapDump >> store [
	^ store
]

{ #category : #accessing }
SnapDump >> store: anObject [
	store := anObject 
]
