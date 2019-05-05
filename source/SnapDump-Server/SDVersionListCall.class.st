Class {
	#name : #SDVersionListCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionListCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDVersionListCall class >> path [
	^ '/projects/{projectName}/versions'
]

{ #category : #accessing }
SDVersionListCall >> get [
	self jsonResponse: (self store projectNamed: projectName) versions 
	
]
