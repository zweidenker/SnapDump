Class {
	#name : #BaselineOfSnapDump,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapDump
}

{ #category : #baselines }
BaselineOfSnapDump >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: #'SnapDump-Core'.
		spec package: #'SnapDump-Core-Tests' with: [ spec requires: #('SnapDump-Core' 'Mocketry') ].
		spec package: #'SnapDump-BasicClient' with: [ spec requires: #('SnapDump-Core' ) ].
		spec package: #'SnapDump-Client' with: [ spec requires: #('SnapDump-BasicClient' ) ].
		spec package: #'SnapDump-Server' with: [ spec requires: #('SnapDump-Core' 'ZincHTTPComponents' 'OpenAPI') ].
		spec package: #'SnapDump-Server-Tests' with: [ spec requires: #('SnapDump-Server' 'Mocketry' ) ].
		spec package: #'SnapDump-UI' with: [ spec requires: #('SnapDump-Client' ) ].

		spec 
			group: 'default' with: #( server 'basic-client' client ui tests);
			group: 'basic-client' with: #( #'SnapDump-BasicClient' );
			group: 'server' with: #( #'SnapDump-Server' 'Cinic');
			group: 'client' with: #( #'SnapDump-Client' );
			group: 'ui' with: #( #'SnapDump-UI' );
			group: 'core' with: #(#'SnapDump-Core' );
			group: 'tests' with: #('SnapDump-Core-Tests' 'SnapDump-Server-Tests').
			
		self mocketry: spec.
		self zinc: spec.
		self cinic: spec.
		self openApi: spec ]

]

{ #category : #baselines }
BaselineOfSnapDump >> cinic: spec [
	spec baseline: 'Cinic' with: [ 
			spec repository: 'github://zweidenker/Cinic'. ]
]

{ #category : #baselines }
BaselineOfSnapDump >> mocketry: spec [
	spec baseline: 'Mocketry' with: [ 
			spec repository: 'github://dionisiydk/Mocketry:v4.0.x'. ]
]

{ #category : #baselines }
BaselineOfSnapDump >> openApi: spec [
	spec baseline: 'OpenAPI' with: [ 
			spec repository: 'github://zweidenker/OpenAPI'. ]
]

{ #category : #baselines }
BaselineOfSnapDump >> zinc: spec [ 
	spec baseline: 'ZincHTTPComponents' with: [ 
		spec 
			loads: #('REST');
			repository: 'github://zweidenker/zinc/repository']
]
