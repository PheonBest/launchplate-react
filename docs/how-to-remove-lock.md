The DynamoDB lock on the shared state may be kept when terraform apply has been interrupted or failed.

You can remove the lock by running the following command:
```bin/sh
cd terraform/live
terraform force-unlock -force <lock_id>
```
