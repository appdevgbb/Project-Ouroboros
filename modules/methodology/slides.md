---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #ccc
---

# Methodology
---

# Methodology

* Why do this? 
* Benchmarking
* Capacity Planning
* Synch/Asynch
* Throughput
* Autoscaling
* USE Method

---
# Methodology
#### Why do this ?

Performance testing can be used as a standard approach for a baseline with metrics and KPIs for our application.

In many cases, the metrics by themselves don't tell you the full story (e.g.: IOPS, Bandwidth, Packets per second, CPU  usage) but they are used to draw the full picture.

---
# Methodology
### Benchmarking

>Benchmarking is the process of **simulating** different workloads on your application **and measuring** application **performance** for each workload. It is the best way to figure out what resources you will need to host your application. Use performance  indicators to assess whether your application is performing as expected or not.

##### [Microsoft Well Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/test-tools)
---
# Methodology
#### Benchmarking

* Know the Azure service limits.

* Measure typical loads.

* Understand application behavior under various scales.

---
# Methodology
#### Benchmarking - Know the Azure service limits.

Verify that your tests (and expected values) are within the current limits of the service in question.  

Tool for the job: [ResourceLimits](https://github.com/mspnp/samples/tree/master/OperationalExcellence/ResourceLimits)

> The ResourceLimits sample shows how to query the limits and quotas for commonly used resources.
##### [Well Architected Framework - Performance testing](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/performance-test)

---
# Methodology
#### Benchmarking - Know the Azure service limits.

`ResourceLimits` showing usage Azure Load Balancers in WestUS

```bash
Name                                          Limit
--------------------------------------------  -------
Load Balancers                                1000
Standard Sku Load Balancers                   1000
Inbound Rules per Load Balancer               250
Frontend IP Configurations per Load Balancer  200
Outbound Rules per Load Balancer              5
```

---
# Methodology
#### Benchmarking - A note on `Throttling`. 

When testing for service limits you might find that your performance tests are being throttled. This can affect your test result and it is likely to happen when your tests are aggressively hitting a service in Azure. 

Knowing how to identify these limits and wether or not you are being throttled will help you with the proper parameters on your testing suit.

---
# Methodology
#### Benchmarking - A note on `Throttling`. 

The [Throttling Resource Manager requests](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/request-limits-and-throttling) serve as a primer when it comes understanding the limits and throttling for the Azure Resource Manager. 

![bg right width:600px](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/media/request-limits-and-throttling/request-throttling.svg)

---
# Methodology
#### Capacity Planning

There is no formula for capacity planning. At best, you'd be able to have a fluid framework that allows you to adapt to changes over time. 

A good approach is to use the results of your benchmark tests to infer a **baseline** and a **target** goal for your application. 

Coupling a baseline line with autoscaling allows for a more organic growth of your application, without allocating resources that might go unsed most of the time.

---
# Methodology
#### Capacity Planning

Here are some questions you could ask about your application:

* How many packets per seconds can I expect before scaling out my web tier?
* What is the average response time from my API ? What is the 95th percentile response time?
* Is my application CPU, Network, or Memory bound ?

---
# Methodology
#### Autoscaling

Autoscaling is an interesting tool that allows for applied elasticity for an application. Take Kubernetes for example. Using the [*Horizontal Pod Autoscaler*](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/), or HPA for short, allows for a deployment to scale in-out within the current boundaries of the cluster.  Currently, HPA can be used with _memory_ or _cpu_ metrics. Some objects cannot be scaled (e.g.: DaemonSets), so HPA while extremely useful will not be applicable for every component in your solution.

---
# Methodology
#### Autoscaling - Beyond the HPA: Using KEDA  

![width:150px](https://keda.sh/img/logos/keda-icon-color.png) If you need other metrics to scale your application [KEDA](https://keda.sh) might be a better solution. KEDA uses the concept of *scalers* as the input for it's autoscaling logic. Examples of scalers are Apache Kafka, [RabbitMQ](https://github.com/kedacore/sample-go-rabbitmq) and [Azure Service Bus](https://github.com/kedacore/sample-dotnet-worker-servicebus-queue).

---
# Methodology
#### USE Method

Developed by Brendan Gregg, [the **USE Method**](http://www.brendangregg.com/usemethod.html)  decomposes every resource in a solution into individual resources that can be analysed for it's **U**tilization, **S**aturation and **E**rrors.

In summary: 

>For every resource, check utilization, saturation, and errors.

---
# Methodology
#### USE Method

* Identify the resources in the solution.
* One by one, check is they have any Errors, Utilization and Saturation.

![bg right](https://www.brendangregg.com/USEmethod/usemethod_flow.png)

---
# Methodology
#### USE Method

To be able to identify the specific area where the performance is being affected, we will proceed by analysing the various resources that make up the cluster, looking for patterns on their Utilization, Saturation and Error. We will go through each one of these components.

---
<style scoped>
table {
    height: 60%;
    width: 78%;
    font-size: 20px;
    position: absolute;
    left: 150px;
    height: 20px;
}
</style>

# Methodology
#### USE Method

| resource | type | metric
| - | - | - 
| CPU |Utilization Saturation Error| CPU Credits Consumed/Remained, Percentage CPU, CPU IO wait time, CPU idle time, CPU Percentage guest OS, CPU user time
| Memory |Utilization Saturation Error| Mem. Percent available, mem used by cache, memory available, memory used.
| | Network |Utilization Saturation Error | Network In, Network Out, Number of Established/Active TCP connections 
| Storage |Utilization Saturation Error	| Disk Queue Length, Disk write time, Disk writes, Disk write guest OS, Disk transfers, Disk transfer time, Disk read time, Disk Read Bytes, Disk Write Bytes, Disk Read Ops/sec, Disk Write Ops/sec.

---
<style scoped>
table {
    height: 60%;
    width: 78%;
    font-size: 20px;
    position: absolute;
    left: 150px;
    height: 20px;
}
</style>

# Methodology
#### USE Method

We could start by applying the USE method from a high level construct by looking at the `pods` and `nodes` of a Kubernetes cluster. 

| resource | type | metric
| - | - | - 
| Node | utilization | kubectl top node; 
| Node | saturation | kubectl top node; kubectl describe node (look in the events section)
| Node | error | kubectl describe node (look in the events section)
| Pod | utilization | kubectl top pod
| Pod | saturation | kubectl describe pod
| Pod | error | kubectl decribe pod; kubectl logs

---
# Methodology
#### Resources

* [USE Method: Linux Performance Checklist](https://www.brendangregg.com/USEmethod/use-linux.html)
* [KEDA](https://keda.sh)
* [Microsoft Well Architected Framework](https://docs.microsoft.com/en-us/azure/architecture/framework)
