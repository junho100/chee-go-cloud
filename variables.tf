variable "aws_access_key" {
  description = "aws access key"
}

variable "aws_secret_key" {
  description = "aws secret key"
}

variable "environment" {
  description = "environment"
}

variable "project_name" {
  description = "project name"
}

variable "db_password" {
  description = "password for the database"
  type        = string
}

variable "db_username" {
  description = "username for the database"
  type        = string
}

variable "db_name" {
  description = "name of the database"
  type        = string
}

variable "domain_name" {
  description = "domain name"
  type        = string
}

variable "discord_bot_token" {
  description = "discord bot token"
  type        = string
}

variable "discord_user_id" {
  description = "discord user id"
  type        = string
}
