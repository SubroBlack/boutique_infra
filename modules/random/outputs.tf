output random_string {
  description = "Randomly generated string to be placed in the name of resrouces"
  value = "${random_string.random.result}"
}