resource "aws_dynamodb_table" "Db-Inventory-Table" {
    billing_mode = "PAY_PER_REQUEST"
    name = "Dynamo-DB-Inventory"
    hash_key = "id"

    attribute {
        name = "id"
        type = "S"
    }

    ttl {
        attribute_name = "TimeToExist"
        enabled        = true
    }
}
