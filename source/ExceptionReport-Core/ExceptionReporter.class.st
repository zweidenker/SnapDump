Class {
	#name : #ExceptionReporter,
	#superclass : #Object,
	#classInstVars : [
		'store'
	],
	#category : 'ExceptionReport-Core'
}

{ #category : #'as yet unclassified' }
ExceptionReporter class >> applyConfig: aConfig [
	store := (ExceptionReportStore withName: aConfig store) new.
	store applyConfig: aConfig
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> configuration [
	<configurationStep>
	^ {  
		#group -> #exceptionReporter.
		#action -> [ :config | ExceptionReporter applyConfig: config ] }
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> hackUIManager [
	UIManager compile: 'logError: anError
		ExceptionReporter handleException: anError.
		super logError: anError'
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> handleException: exception [

	store ifNotNil: [
		store storeException: exception ]
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> handleLogEvent: event [
	^ self handleException: event exception
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> handleZnLogEvent: event [
	^ self handleException: event exception
]

{ #category : #'as yet unclassified' }
ExceptionReporter class >> registerOnZnLog [
	^ ZnLogEvent announcer
		when: ZnServerErrorEvent do: [ :event |
			self handleZnLogEvent: event ]
]

{ #category : #accessing }
ExceptionReporter class >> store [
	^ store
]

{ #category : #accessing }
ExceptionReporter class >> store: anObject [
	store := anObject
]
