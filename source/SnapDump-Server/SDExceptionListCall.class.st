Class {
	#name : #SDExceptionListCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDExceptionListCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDExceptionListCall class >> parameterVersiontString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Name of the version'

]

{ #category : #accessing }
SDExceptionListCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/exceptions'
]

{ #category : #accessing }
SDExceptionListCall >> get [

	self jsonResponse: ((self projectNamed: projectName) versionAt: versionString) exceptions 
	
]
