module "f-talk-lb" {
  source              = "./components/f-talk-internal-loadbalancer"
  resource_group_name = ""
  nic_names           = [""] # Update here with the names of the Factory-Talk server's existing NICs
  location            = ""
}