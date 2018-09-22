# Installation

In order to succesfully build your drone application in kubernetes
you will have to create:

- Persistent Volume Claim
- Service
- Server Deployment
- Agent Deployment

### [Persistent Volume Claim](https://kubernetes-on-aws.readthedocs.io/en/latest/user-guide/using-volumes.html)

Kubernetes leverages aws' [Elastic Block Store | EBS](https://aws.amazon.com/ebs/) in order to persist the application's data. 
It is a physical resource that the app can mount on creation or restart.

```
kubectl create -f drone.io/server-volume.yml
```

### [Service](https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service)

Services abstract the access to the application and route external traffic into kubernete's cluster. This could be achieved more elegantly with kubernete's [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/). This service however will make use of a loadbalancer.

- Create the service
```
kubectl create -f drone.io/server-service.yml
```

- Check the service availability

```
kubectl get service
```

```
NAME           TYPE           CLUSTER-IP     EXTERNAL-IP                                            PORT(S)                 AGE
drone-server   LoadBalancer   100.xx.xx.15   sha512hash.eu-west-2.elb.amazonaws.com   80:xx/TCP,443:xx/TCP,9000:xx/TCP      47s
kubernetes     ClusterIP      100.xx.xx.1     <none>                                                443/TCP                 35m

```

- [Update or create your CNAME's resouce record set](https://gist.github.com/tcbyrd/ffb5f596322cee976ae864f3d8061c6a), its probably a lot easier from the GUI to be honest.

- [Generate an ssl certificate](https://aws.amazon.com/certificate-manager/)


### [Server setup](http://docs.drone.io/installation/)

The following sets a kubernetes deployment to manage drone's server. [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) is were kubernetes really shines it allows you to:

- Rollout replicas on outages
- Declare new states
- Rollback
- Scale
- Pause 
- Clean up

Drone's server deployment needs some configuration

The drone container is built from [scratch](https://hub.docker.com/_/scratch/) and is therefore completely empty. It does not have bash installed, or any other utilities.


