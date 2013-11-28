# AppFlight

Release .ipa file over the cloud storage privately like TestFlight. All files related to .ipa was uploaded to the cloud storage, then S3 and Route53 configurations are strongly required for your convinience.

## Installation

    $ gem install appflight

## Building & Releasing

`appflight` can build the .ipa file by `ipa` command of shenzhen in your PATH. In prior to building the app, .env file will be required with filled environmental variables. The env.appflight file would be helpful.
Normally S3 bucket name is assigned as get.YOURDOMAIN to avoid some trouble.

    $ cd /path/to/iOS_Project/
    $ appflight generate
    $ vim .env.app
    $ vim .env.s3
    $ appflight build
    $ appflight release:s3
    
## Get Your App

Please make sure that your S3 bucket is public, then the end-point of S3 could be found in the S3 dashboard. Within Route 53, any A record would have directed to that end-point. So you can specify the landing page like get.YOURAPP.com.

## .env Sample file

```
### Aws
AWS_ACCESS_KEY_ID: AKIAB132JA711UOJPWA
AWS_SECRET_ACCESS_KEY: ZclgzgPHzuaxIkaLIuEOlhn3DcWXt1umxA7
S3_BUCKET: get.yourapp.com
AWS_REGION: ap-northeast-1

### Build Context
provision: 57A87197-DE9D-DEAD-BEEF-89DFF4F18A91
configure: "Release"

### plist Context
ipa_name: yourapp.ipa
bundle_id: com.yourapp

### Web Page Context
app_name: YourAppName
app_desc: YourApp is great.
get_domain: get.yourapp.com
```
