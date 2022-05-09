# Fetching just one public IP in the list

output "pubic_ip" {
  description = "public ip"
  value       = aws_instance.web[0].public_ip
  sensitive = false
}

# Feching all the public IPs in the list
output "pubic_ip1" {
  description = "public IPs"
  value       = aws_instance.web[*].public_ip
  sensitive = false
}

# what if i need just two pub IP in the list?
output "pubic_ip2" {
  description = "public IPs"
  value       = slice(aws_instance.web[*].public_ip,0, 2)
  sensitive = false
}

# For loop with  output (all pub ips)
 output "public_ip" {
   description = "public IPs"
   value = [for public_ip in aws_instance.web: public_ip.public_ip]
 }

 output "ec2_arn" {
   description = "ec2 arn's"
   value = [for arn in aws_instance.web: arn.arn]
 }