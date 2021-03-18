# ESK chart

This is the official helm chart for the [External Secrets for Kubernetes](https://github.com/esk8s/esk) project.


# Configuration

## General configs

| Parameter               | Description | Default |
| --- | --- | --- |
| imagePullSecrets        | Docker registry secret names as an array	 | [] (does not add image pull secrets to deployed pods) |
| nameOverride            | String to partially override resource names | "" |
| fullnameOverride        | String to fully override resource names | "" |
| secretRBAC.backend      | Use backend authorization mechanisms | false |
| secretRBAC.defaultAllow | Allow or deny by default (not SecretPolicy matches) | false |


## Backends configuration

| Parameter                         | Description | Default |
| --- | --- | --- |
| backends.vault.enabled            | Enable vault backend | false |
| backends.vault.address            | Address of the vault instance | |
| backends.vault.token_path         | Path to the vault token to use to communicate with the instance | |
| backends.vault.ca_cert            | Path to a file containing the certificate authority of the Vault instance certificate | false |
| backends.vault.defaultMountPoint  | Mount point to use when a secret created for vault backend has no defined path | kv |
| backends.aws.enabled              | Enable aws backend | false |
| backends.aws.region               | Region of the AWS cluster and secrets | |
| backends.aws.accountID            | AWS Account ID used to create the required ARNs for the secrets | |
| backends.gcp.enabled              | Enable aws backend | false |
| backends.gcp.projectID            | GCP Project ID used to create the required paths for the secrets | |


## Operator configuration

| Parameter                           | Description | Default |
| --- | --- | --- |
| operator.enabled                    | Enable or disable the esk-operator instance | true |
| operator.replicas                   | Number of replicas for the operator deployment. Untested with more replicas | 1 |
| operator.rbac.enabled               | Whether to create the required ClusterRole and ClusterRoleBinding for the operator | true |

[Common configs](#Common-configs) are also supported for this component.


## Injector configuration

| Parameter             | Description | Default |
| ---                   | --- | --- |
| injector.enabled      | Enable or disable the esk-operator instance | true |
| injector.replicas     | Number of replicas for the operator deployment. Untested with more replicas | 1 |
| injector.rbac.enabled | Whether to create the required ClusterRole and ClusterRoleBinding for the injector | true |
| injector.certPath     | Path to the TLS certificate to serve for the injector | /tlsconfig/tls.crt |
| injector.keyPath      | Path to the TLS key to serve for the injector | /tlsconfig/tls.key |
| injector.service.type | Type of the service for the injector | ClusterIP |
| injector.service.port | Port used by the injector service | 443 |

[Common configs](#Common-configs) are also supported for this component.


## Certificate generator configuration

| Parameter                                   | Description | Default |
| ---                                         | --- | --- |
| certificateGenerator.enabled                | Enable or disable the automatic generation of certificates for the injector | true |
| certificateGenerator.autoApproveCertificate | Whether to auto approve the generated CertificateSigningRequest | 1 |

[Common configs](#Common-configs) are also supported for this component.


## Init Container configuration

| Parameter | Description | Default |
| --- | --- | --- |
| init.image.repository | Docker image for the webclient | esk/esk-init |
| init.image.tag        | Tag for the docker image | latest |
| init.image.pullPolicy | Pull policy for the docker image | IfNotPresent |


## Common configs

It's possible to provide the following values for the injector, operator and certificateGenerator. Just replace `component` with either `injector`, `operator` or `certificateGenerator`.

| Parameter | Description | Default |
| --- | --- | --- |
| component.enabled                    | Enable or disable the automatic generation of certificates for the injector | true |
| component.image.repository           | Docker image for the component | |
| component.image.tag                  | Tag for the docker image | latest |
| component.image.pullPolicy           | Pull policy for the docker image | IfNotPresent |
| component.serviceAccount.create      | Enable or disable the creation of a service account to be used by the component | true |
| component.serviceAccount.name        | Name of the service account to create | {{ .Release.Name }}-{{ component }} |
| component.serviceAccount.annotations | Annotations given to the service account | {} |
| component.podAnnotations             | Annotations given to the pods spawned by the component deployment | {} |
| component.podSecurityContext         |  | {} |
| component.securityContext            |  | {} |
| component.resources                  | CPU/Memory resource requests/limits for component pods | {} |
| component.nodeSelector               | Node labels for component pod assignment | {} |
| component.affinity                   | Affinity for component pod assignment | {} |
| component.env                        | Environment variables for the main container in the component pods | {} |
| component.tolerations                | Tolerations for component pod assignment | [] |
| component.extraVolumeMounts          | Extra volume mounts used by the main container in the component pods | [] |
| component.extraVolumes               | Extra volumes to be used by the component pods | [] |
| component.extraSecretEnvironmentVars | List of env vars loaded from secrets | [] |
