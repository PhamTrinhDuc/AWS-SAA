output "private_bucket_id" {
  value = module.s3_private.bucket_id
}

output "private_bucket_arn" {
  value = module.s3_private.bucket_arn
}

output "website_bucket_id" {
  value = module.s3_website.bucket_id
}

output "website_url" {
  value = "http://${module.s3_website.website_endpoint}"
}