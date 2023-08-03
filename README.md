# simpleScalingApp
Project showing the use of AWS horizontal scaling with an application load balancer
The app will be placed in an auto-scaling group with t2.micro ec2 machines. And a loadbalancer will service traffic.
This is a good demonstration for basic high availablity.

## Cloudfront example
There is also a static webpage hosting that will be stored on s3 and distributed with cloudfront when going to the website will show your current time.

## Image versioning
Since auto scaling groups are able to scale new images using ami-s. It is good practice to create an image so that your application can be spun up quickly.
We need to build and version these images, and to do this we can use packer.

## ci/cd
Github actions will be responsible for deploying images and configuring infrastructure.
