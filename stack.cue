package main

import (
	"guku.io/devx/v1"
	"guku.io/devx/v1/traits"
	"demo.com/v1/platforms"
)

builders: platforms.Builders

stack: v1.#Stack & {
	$metadata: stack: "service-a"
	components: {
		bucket: {
			traits.#S3CompatibleBucket
			s3: {
				prefix:     "guku-io-"
				name:       "my-bucket"
				versioning: true
			}
		}
		apiKey: {
			traits.#Secret
			secrets: apiKey: name: "apikey-a"
		}
		app: {
			traits.#Workload
			traits.#Exposable
			traits.#Replicable
			containers: default: {
				image: "hashicorp/http-echo"
				args: ["-text", "hello world"]
				resources: requests: {
					cpu:    "256m"
					memory: "512M"
				}
				env: {
					API_KEY:     apiKey.secrets.apiKey
					BUCKET_NAME: bucket.s3.fullBucketName
				}
			}
			endpoints: default: ports: [
				{port: 5678},
			]
			replicas: min: 2
		}
	}
}
