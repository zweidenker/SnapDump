Class {
	#name : #ExceptionReportServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#category : 'ExceptionReport-Rest'
}

{ #category : #'error handling' }
ExceptionReportServerDelegate >> serverError: request exception: exception [
	ExceptionReporter handleException: exception.
	^ super serverError: request exception: exception
]
