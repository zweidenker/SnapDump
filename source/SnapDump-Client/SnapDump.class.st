Class {
	#name : #SnapDump,
	#superclass : #Object,
	#classInstVars : [
		'store'
	],
	#category : #'SnapDump-Client'
}

{ #category : #'as yet unclassified' }
SnapDump class >> applyConfig: aConfig [
	store := (SDStore withName: aConfig store) new.
	store applyConfig: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<configurationStep>
	^ {  
		#group -> #SnapDump.
		#action -> [ :config | SnapDump applyConfig: config ] }
]

{ #category : #'as yet unclassified' }
SnapDump class >> hackUIManager [
	UIManager compile: 'logError: anError
		ExceptionReporter handleException: anError.
		super logError: anError'
]

{ #category : #'as yet unclassified' }
SnapDump class >> handleException: exception [

	store ifNotNil: [
		store storeException: exception ]
]

{ #category : #'as yet unclassified' }
SnapDump class >> handleLogEvent: event [
	^ self handleException: event exception
]

{ #category : #'as yet unclassified' }
SnapDump class >> handleZnLogEvent: event [
	^ self handleException: event exception
]

{ #category : #'as yet unclassified' }
SnapDump class >> registerOnZnLog [
	^ ZnLogEvent announcer
		when: ZnServerErrorEvent do: [ :event |
			self handleZnLogEvent: event ]
]

{ #category : #accessing }
SnapDump class >> store [
	^ store
]

{ #category : #accessing }
SnapDump class >> store: anObject [
	store := anObject
]
