Class {
	#name : #SDExceptionSnapshotListCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString',
		'exceptionId'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDExceptionSnapshotListCall class >> parameterExceptionId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'exceptionId';
		in: #path;
		beString;
		required: true;
		description: 'Exception identitfier'

]

{ #category : #accessing }
SDExceptionSnapshotListCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDExceptionSnapshotListCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version identitfier'

]

{ #category : #accessing }
SDExceptionSnapshotListCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/exceptions/{exceptionId}/snapshots'
]

{ #category : #accessing }
SDExceptionSnapshotListCall >> get [
	self jsonResponse: (self exceptionAt: exceptionId project: projectName 
	  version: versionString ) snapshots
	
]
