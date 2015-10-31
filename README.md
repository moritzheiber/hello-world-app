# Hello world! service

This is a small "Hello world!" service displaying a website which says "Hello world!" after start it using

    ruby start.rb

on port `8000`.

It can be deployed to AWS using [CloudFormation](https://aws.amazon.com/cloudformation/). It's also prepared to be using in a pipeline environment on [Snap CI](https://snap-ci.com).

# Setup

You'll need:

- Ruby 2.x (Tested with Ruby 2.0.x and Ruby 2.2.x; should work with any Ruby >= 2.x)

For just running the application.

And for deploying on AWS:

- [Bundler >= 1.10.5](http://bundler.io) for installing the gems needed to deploy to AWS
- An AWS account + IAM account (don't use your root credentials) and a properly set up command line (i.e. `$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` are valid).
- A S3 bucket: Its name from this example is `hello-world-app`.
- A IAM instance role called `hello-world` with rights to fetch resources from said bucket. An example would be:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::hello-world-app/*"
        }
      ]
    }

- A hosted zone in Route53: It's set to 'aws.heiber.im' in this example, you might want to change this in the template depending on your DNS configuration
  - *Note: You may also skip this step and remove the zone from the CloudFormation template alltogether*
- A SSH key pair you previously created: Its name needs to go into the `keyName` field of the `LaunchConfig` resource.
  - *Note: You may also skip this step and remove the keypair definition from the `LaunchConfiguration` block in the CloudFormation template.*

# Running the app

If you care to run this app locally on your machine you only need to run it with ruby:

    ruby start.rb

this will open port 8000 and display a web page saying "Hello world!".

# Deploying on AWS

There is a `Rakefile` which is using [Autostacker24](https://github.com/AutoScout24/autostacker24) to deploy this app to CloudFormation on AWS. There are a few rake commands which you can use:

    $ bundle exec rake -T
    rake create_or_update  # create or update stack
    rake delete            # delete stack
    rake deploy            # deploy the app
    rake dump              # dump template
    rake publish           # publish artifacts to S3
    rake test              # runs tests
    rake validate          # validate template

You will need to have your CLI set up already, i.e. `$AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` need to be set correctly. You can then run:

    # Install all the necessary gems to deploy to AWS using Autostacker24
    bundle install --path vendor/bundle
    # Publish the artifacts needed on the EC2 instance we're going to use; mainly `index.html` and `start.rb`
    # $AWS_REGION controls the region of AWS we're going to use; $VERSION is the version you want to publish to S3
    # When deploying using Snap CI this gets filled automatically
    AWS_REGION="<your-region>" VERSION="<your-version>" bundle exec rake publish
    # Engage Autostacker24 and let it do it's magic using CloudFormation
    # $AWS_REGION again is the region you want to deploy your stack in; $VERSION has to be the same as in the publish stage, otherwise the deployment is going to fail
    AWS_REGION="<your-region>" VERSION="<your-version>" bundle exec rake deploy

This will start the app in a stack on AWS, including a VPC, subnets, security groups etc., using one instance behind an ELB, including (by default) a DNS record and a SSH key pair attached to the instance being started. It uses an [AutoScalingGroup](https://aws.amazon.com/autoscaling/) to manage rolling deployments.

After a short amount of time (remember: It takes some time to deploy new EC2 instances) you should see your results at http://hello-world.<insert-your-dns-domain-here>

## Delete all resources

To get rid of all the resources you created with this experiment just run:

    bundle exec rake delete

## Verify template changes

To make sure your template is still valid JSON after having modified it run:

    bundle exec rake validate

## Running tests associated with the app

You can run

    bundle exec rake test

to cycle through any tests the app needs to go through.

*TODO: Add at least one meaningful test*
