| apiHandler healthHandler metricsHandler prefixHandler server dockerTag |
Author fullName: 'docker'.

ZnLogEvent logToTranscript.

SnapDump hackUIManager.
"SnapDump current  store: (SDFilesystemStore new path: '/snapshots')."

dockerTag :=  (OSEnvironment current getEnv: 'DOCKER_TAG').
SDServer version: dockerTag.

SDServer startOnPort: 5555 path: '/snapshots'
