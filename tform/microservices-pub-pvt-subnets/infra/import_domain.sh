#!/bin/bash

# replace the values with the real values of zone id etc. 

# The following simple method copies the resources already in the aws account into the tf state. 
# Its useful for retaining domain and hosted zones to not have them change.
# When doing a destory, the 'teraform state rm <>' should be called on the same resources so that they are not deleted while destroy.

terraform import aws_route53_zone.AAA XXXXXXX 
terraform import aws_route53_record.BBB XXXXXXX_YYYYYY_ZZZZZZ
terraform import aws_route53_record.CCC XXXXXXX_YYYYYY_ZZZZZZ