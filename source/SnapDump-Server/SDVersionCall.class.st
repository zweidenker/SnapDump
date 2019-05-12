Class {
	#name : #SDVersionCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDVersionCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version identitfier'

]

{ #category : #accessing }
SDVersionCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}'
]

{ #category : #accessing }
SDVersionCall >> get [
	self jsonResponse: ((self store projectNamed: projectName) versionAt: versionString) 
	
]
