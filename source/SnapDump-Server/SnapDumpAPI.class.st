Class {
	#name : #SnapDumpAPI,
	#superclass : #OpenAPI,
	#classVars : [
		'path'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SnapDumpAPI class >> rootCallClass [
	^ SDOpenAPICall 
]

{ #category : #accessing }
SnapDumpAPI >> info [
	^ OAInfo new 
		description: 'SnapDump API';
		version: SDServer repositoryDescription;
		title: 'SnapDump API';
		contact: (OAContact new
			name: 'Norbert Hartl';
			email: 'norbert@2denker.de';
			url: 'http://zweidenker.de');			
		license: (OALicense new
			name: 'proper';
			url: 'http://no.url.yet/')
     
]

{ #category : #accessing }
SnapDumpAPI >> openapi [
	^ '3.0.0'
]
