resource "null_resource" "submit_code_to_s3" {
    provisioner "local-exec" {
        command = <<EOT
                        cd ../../frontend
                        npm run build
                        cd dist
                        aws s3 cp . s3://${var.bucket_name}/ --recursive
                        aws cloudfront create-invalidation --distribution-id ${var.cloudfrontid} --paths "/*"
                EOT
    }

    triggers = {
        always_run = timestamp() # Esto asegura que siempre se ejecute
    }
}