# tf-for_each-data-invalid-index-poc

Proof of concept – problems with for_each and data

## Steps to recreate

1.  Clone the repository

2.  `terraform apply -var-file=values.tfvars` first time

3.  Uncomment the second entry for variable value
    `s3_sns_notification_details` and save

4.  `terraform apply -var-file=values.tfvars` second time and *ERROR*

    ```shell
    aws_sns_topic.this["first"]: Refreshing state... [id=arn:aws:sns:ap-southeast-2:372213875655:first]
    aws_s3_bucket.this: Refreshing state... [id=tf-data-invalid-index-poc]
    data.aws_iam_policy_document.sns_publish["first"]: Refreshing state... [id=3665224188]
    aws_sns_topic_policy.sns_publish["first"]: Refreshing state... [id=arn:aws:sns:ap-southeast-2:372213875655:first]
    aws_s3_bucket_notification.this: Refreshing state... [id=tf-data-invalid-index-poc]

    Error: Invalid index

      on main.tf line 58, in resource "aws_sns_topic_policy" "sns_publish":
      58:   policy = data.aws_iam_policy_document.sns_publish[each.key].json
        |----------------
        | data.aws_iam_policy_document.sns_publish is object with 1 attribute "first"
        | each.key is "second"

    The given key does not identify an element in this collection value.
    ```

5.  `terraform destroy`
