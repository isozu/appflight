## Installation

    $ gem install appflight

## Building & Releasing

appflight can build the .ipa file by `ipa` command of shenzhen in your PATH. In prior to building the app, .env file would be required filling the environment variables. The .env.appflight file would be helpful.

    $ cd /path/to/iOS_Project/
    $ cp /path/to/gem/.env.appflight .env
    $ appflight build
    $ appflight release:s3
    
## Get Your App

You need to make the S3 bucket public, then the end-point of S3 could be found in the S3 dashboard. Based on Route 53, any A record would has directed to that end-point. So you can specify the landing page like get.YOURDOMAIN.com.


## .env Sample file

```
### Aws
AWS_ACCESS_KEY_ID: AKIAB132JA711UOJPWA
AWS_SECRET_ACCESS_KEY: ZclgzgPHzuaxIkaLIuEOlhn3DcWXt1umxA7
S3_BUCKET: get.yourapp.com
AWS_REGION: ap-northeast-1

### Build Context
provision: 57A87197-DE9D-DEAF-BEEF-89DFF4F18A91
configure: "Release"

### plist Context
ipa_name: yourapp.ipa
bundle_id: com.yourapp

### Web Page Context
app_name: YourAppName
app_desc: YourApp is great.
get_domain: get.yourapp.com
```
