Class {
	#name : #SDExceptionFreeSlotsCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString',
		'exceptionId'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDExceptionFreeSlotsCall class >> parameterExceptionId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'exceptionId';
		in: #path;
		beString;
		required: true;
		description: 'Exception identitfier'

]

{ #category : #accessing }
SDExceptionFreeSlotsCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDExceptionFreeSlotsCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version identitfier'

]

{ #category : #accessing }
SDExceptionFreeSlotsCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/exceptions/{exceptionId}/freeslots'
]

{ #category : #accessing }
SDExceptionFreeSlotsCall >> get [

	self jsonResponse: (self store freeSlotsForExceptionId: exceptionId project: projectName version: versionString) 
	
]
