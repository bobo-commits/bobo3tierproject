# get hosted zone details
data "aws_route53_zone" "hosted_zone" {
  # This is the ID of the hosted zone you want to use
  # You can find this in the AWS console or use the aws cli to get it
  name = "bustercloud.com"
}

# create a record set in route53
#terraform aws route53 record set
resource "aws_route53_record" "www" {
  # This is the name of the record set you want to create
  # You can use any name you want, but it should be unique within the hosted zone
  name    = "www.bustercloud.com"
  type    = "A"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id

  alias {
    # This is the name of the record set you want to create
    # You can use any name you want, but it should be unique within the hosted zone
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = false
  }
}

