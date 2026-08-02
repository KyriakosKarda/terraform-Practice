resource "random_id" "random_id_for_s3_bucket" {
  byte_length = 8

}

data "aws_s3_bucket" "my_bucket_url" {
  bucket = aws_s3_bucket.my_bucket.bucket
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "s3-bucket-from-cli-${random_id.random_id_for_s3_bucket.hex}"
}

output "stdout" {
  value = "My s3 bucket ID is: ${aws_s3_bucket.my_bucket.id}"
}

output "stdout2" {
  value = "My s3 bucket arn is= ${data.aws_s3_bucket.my_bucket_url.arn}"

}