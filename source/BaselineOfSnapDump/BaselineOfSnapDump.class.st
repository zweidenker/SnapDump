Class {
	#name : #BaselineOfSnapDump,
	#superclass : #BaselineOf,
	#category : #BaselineOfSnapDump
}

{ #category : #baselines }
BaselineOfSnapDump >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec package: #'SnapDump-Core'.
		spec package: #'SnapDump-Server-Tests' with: [ spec requires: #('Mocketry' ) ].
		spec package: #'SnapDump-Server' with: [ spec requires: #('SnapDump-Core' 'ZincHTTPComponents' ) ].
		spec package: #'SnapDump-Client'.
		spec package: #'SnapDump-UI'.
		spec baseline: 'Mocketry' with: [ 
			spec repository: 'github://dionisiydk/Mocketry:v4.0.x'. ].
		spec baseline: 'ZincHTTPComponents' with: [ 
				spec 
					loads: #('REST');
					repository: 'github://zweidenker/zinc/repository'].
		spec 
			group: 'default' with: #( server client ui tests);
			group: 'server' with: #( #'SnapDump-Rest' );
			group: 'client' with: #( #'SnapDump-Client' );
			group: 'ui' with: #( #'SnapDump-UI' );
			group: 'core' with: #(#'SnapDump-Core' );
			group: 'tests' with: #('SnapDump-Server-Tests');
			group: 'all' with: #( #'SnapDump-Core'  #'SnapDump-Rest' #'SnapDump-Client' )].

]
