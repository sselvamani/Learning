# Prepare the server 

Adduser

      sudo adduser  kartook
      sudo usermod -aG sudo kartook
      sudo apt update -y && sudo apt upgrade -y

Swap Off 

      sudo swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
Set the hostname 

      $ sudo hostnamectl set-hostname "k8s-master"     // Run this command on master node
      $ sudo hostnamectl set-hostname "k8s-node-0"     // Run this command on node-0
      $ sudo hostnamectl set-hostname "k8s-node-1"     // Run this command on node-1


Update the  entries in "/etc/hosts" files on each node,

      192.168.1.100   k8s-master
      192.168.1.101   k8s-node-0
      192.168.1.102   k8s-node-1
hostname

#Install Containerd runtime  on all the hosts 

Configure required modules
First load two modules in the current running environment and configure them to load on boot

      $sudo modprobe overlay
      $sudo modprobe br_netfilter
      $cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
      $overlay
      $br_netfilter
      $EOF

Configure required sysctl to persist across system reboots

      $cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
      $net.bridge.bridge-nf-call-iptables  = 1
      $net.ipv4.ip_forward                 = 1
      $net.bridge.bridge-nf-call-ip6tables = 1
      $EOF

Apply sysctl parameters without reboot to current running enviroment

      $sudo sysctl --system

Install containerd packages

      $sudo apt-get update 
      $sudo apt-get install -y containerd

Create a containerd configuration file
      sudo su -
      mkdir -p /etc/containerd

/Set the cgroup driver for runc to systemd
/Set the cgroup driver for runc to systemd which is required for the kubelet.
/For more information on this config file see the containerd configuration docs here and also here.

      containerd config default | sudo tee /etc/containerd/config.toml
      sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml



service state of containerD

      systemctl restart containerd
      systemctl enable --now containerd
      systemctl status containerd

And that’s it, from here you can install and configure Kubernetes on top of this container runtime. In an upcoming post, I will bootstrap a cluster using containerd as the container runtime.


#     Master node
      lsmod | grep br_netfilter
      sudo systemctl enable kubelet

      sudo kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
      sudo kubectl get nodes
      sudo kubectl get nodes -o wide

      sudo kubeadm init

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
      sudo kubeadm config images pull --cri-socket /run/containerd/containerd.sock
  kubectl get nodes -o wide
  kubectl cluster-info







Learned : 
      If containerd versions are different ,there is no issue found. 




