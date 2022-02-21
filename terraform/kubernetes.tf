# Query small instance size
data "civo_size" "small" {
  filter {
    key      = "name"
    values   = ["g3.small"]
    match_by = "re"
  }

  filter {
    key    = "type"
    values = ["instance"]
  }
}

# Create a network
resource "civo_network" "dev-network" {
  label = "dev-network"
  region = "LON1"
}

# Create a firewall
resource "civo_firewall" "dev-firewall" {
  name       = "dev-firewall"
  network_id = civo_network.dev-network.id
  region = "LON1"
}

# Create a firewall rule
resource "civo_firewall_rule" "kubernetes" {
  firewall_id = civo_firewall.dev-firewall.id
  action      = "allow"
  protocol    = "tcp"
  start_port  = "6443"
  end_port    = "6443"
  cidr        = ["0.0.0.0/0"]
  direction   = "ingress"
  label       = "kubernetes-api-server"
  region = "LON1"
}

# Create a cluster
resource "civo_kubernetes_cluster" "dev-cluster" {
  region = "LON1"
  name   = "DevCluster"
  #applications = "Redis,Linkerd:Linkerd & Jaeger"
  applications      = ""
  num_target_nodes  = 3
  target_nodes_size = element(data.civo_size.small.sizes, 0).name
  network_id        = civo_network.dev-network.id
  firewall_id       = civo_firewall.dev-firewall.id
}
