# dead-letter-rider
The internal rider service for dead-letter

## Spec
The rider service will be handling all CRUD operations related to individual riders, besides creation (which is instead handled by rider-auth)

**Required Methods**
- Fetch riders
    - Get a rider (by email or ID) from the DB service over gRPC
    - Return the rider via the message queue
- Update a rider
    - Consume rider update messages from the message queue
    - Use the DB service over gRPC to update the rider
    - Return the new rider via the message queue
- Delete a rider
    - Consume the rider delete message from the message queue
    - Delete the corresponding rider
- List riders
    - List riders under a certain criteria from the DB service over gRPC
    - Return the list

## Important Cluster Info
- The DB service can be located at `dead-letter-data.dead-letter.svc.cluster.local` within the cluster
- The message bus can be located at `rabbitmq-dead-letter.rabbitmq-dead-letter.svc.cluster.local` within the cluster
- Ensure you are running through Tilt to be able to interface with both services
- These variables will be automatically injected into the container via Kubernetes under these environment variables:
    - DB_SERVICE_URL
    - MQ_URL

## Generating Client Stubs
- You can generate Python client stubs using the Make target: `make proto/gen`
- You will also need to install `protoc-gen-python`
    - Install instructions [here](https://github.com/danielgtaylor/python-betterproto)

## Usage
1. Configure the personal access token under the CR_PAT variable in the GitHub Actions Secrets
2. On push, the workflow will run and 
    - Build the Docker image
    - Publish the Docker image under USERNAME/REPO_NAME:COMMIT_SHA to the GHCR (not Docker hub)
