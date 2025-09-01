resource "aws_cloudwatch_log_group" "app_logs" {
name = "/${var.environment}/app"
retention_in_days = 14
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {
alarm_name = "high-cpu-${var.environment}"
comparison_operator = "GreaterThanThreshold"
evaluation_periods = 2
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = 300
statistic = "Average"
threshold = 80
alarm_actions = []
}


output "log_group_name" { value = aws_cloudwatch_log_group.app_logs.name }