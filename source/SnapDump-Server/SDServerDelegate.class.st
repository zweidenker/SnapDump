Class {
	#name : #SDServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#instVars : [
		'store'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDServerDelegate >> handlerRequest: aRequest [

	^ super handleRequest: aRequest
]

{ #category : #'error handling' }
SDServerDelegate >> serverError: request exception: exception [
	
	[ self store storeSnapshot: (exception asSnapshot
		projectName: 'SnapDump';
		versionString: (SDServer version ifNil: [ 'None' ]);
		yourself ) ]
		on: Error do: [ :err | "nothing we can do here" ]	.
	^ super serverError: request exception: exception
]

{ #category : #accessing }
SDServerDelegate >> store [
	^ store
]

{ #category : #accessing }
SDServerDelegate >> store: anObject [
	store := anObject
]
