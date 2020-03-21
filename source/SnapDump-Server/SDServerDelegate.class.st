Class {
	#name : #SDServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#instVars : [
		'store'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #'error handling' }
SDServerDelegate >> serverError: request exception: exception [
	Transcript show: (String streamContents: [:stream | exception signalerContext errorReportOn: stream ]); cr.
	[ 
	Transcript show: 'trying to store server error'; cr.
	self store
		storeSnapshot:
			(exception asSnapshot
				projectName: 'SnapDump';
				versionString: SDServer version;
				yourself) ]
		on: Error
		do: [ :err | 
			"nothing we can do here"
			Transcript
				show:
					(String
						streamContents: [ :stream | 
							stream
								nextPutAll: 'Unable to report server internal error: ';
								nextPutAll: err description printString ]);
				cr ].
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
