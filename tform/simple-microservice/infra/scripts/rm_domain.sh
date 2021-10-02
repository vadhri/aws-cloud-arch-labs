#!/bin/bash

# remove items from state that should not be destoryed in the aws env.

terraform state rm aws_route53_record.primary_with_www
terraform state rm aws_route53_record.primary
terraform state rm aws_route53_zone.primary