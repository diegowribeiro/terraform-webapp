#!/bin/bash
PATH=$PATH:$TERRAFORM_HOME
export PATH
terraform get --update
terraform init -backend-config="key=${Project}-webapp.terraform.tfstat"
sleep 10
terraform plan -var PlanName=${PlanName} -var PlanRGName=${PlanRGName} -var Project=${Project} -var env=${env} -var object_id=${object_id}
terraform ${action} -auto-approve -var PlanName=${PlanName} -var PlanRGName=${PlanRGName} -var Project=${Project} -var env=${env} -var object_id=${object_id}
