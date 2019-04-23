Class {
	#name : #SnapDumpServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#category : #'SnapDump-Server-REST'
}

{ #category : #'error handling' }
SnapDumpServerDelegate >> serverError: request exception: exception [
	SnapDump handleException: exception.
	^ super serverError: request exception: exception
]
