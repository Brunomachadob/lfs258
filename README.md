
* To spin up the machines:
```shell script
terraform plan
```

* Login into the master and run:
```shell script
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown $(id -u):$(id -g) "$HOME"/.kube/config
```

* Get the worker join script from the master logs
```shell script
sudo journalctl -u google-startup-scripts.service
```

* Login into the worker machine and execute the command copied above


* After finished using destroy the resources
 Only the machines:
```shell script
terraform destroy -target google_compute_instance_from_template.lfclass_master -target google_compute_instance_from_template.lfclass_worker1
```

Everything:
```shell script
terraform destroy
```