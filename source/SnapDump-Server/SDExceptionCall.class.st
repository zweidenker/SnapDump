Class {
	#name : #SDExceptionCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionName',
		'exceptionId'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDExceptionCall class >> parameterExceptionId [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'exceptionId';
		in: #path;
		beString;
		required: true;
		description: 'Identify a given exception within the specified project-version context'
]

{ #category : #accessing }
SDExceptionCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project to which the exception belongs to'
]

{ #category : #accessing }
SDExceptionCall class >> parameterVersionName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the version to which the exception belongs to'
]

{ #category : #accessing }
SDExceptionCall class >> path [
	^ 'project/{projectName}/version/{versionName}/exceptions/{exceptionId}'
]

{ #category : #public }
SDExceptionCall >> get [
	self jsonResponse: (self store exceptionAt: exceptionId project: projectName version: versionName)
]
