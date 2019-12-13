# TwinPush for notifications
The **twinpush** gem lets your ruby backend manage [TWINPUSH](https://developers.twinpush.com/) notifications.
## Installation
```ruby
$ gem install twinpush
```

or in your `Gemfile` just include it:

```ruby
gem 'twinpush'
```
## Requirements
Tested in Ruby versions:
- `2.3.8`

## Usage
To send a notification to one or more devices, you must first initialise a new TWINPUSH class with your TWINPUSH [credentials](https://developers.twinpush.com/developers/api#authentication) and then call the create method.

Creates a new notification to be delivered from the platform (_[See more](https://developers.twinpush.com/developers/api#post-create)_):

```ruby
require 'twinpush'
twinpush = TWINPUSH.new(app_id: 'cs555ab2356a37a0', 
                        subdomain: 'subdomain-test', 
                        api_token: "1c5cabc4055e03c64f123d9dbfb4d0e9", 
                        api_token_creator: "ca044e0bc6a4f1cg23d9dbfb4251dhy6")

twinpush.create({"broadcast": true, 
                 "title": "Welcome to TwinPush", 
                 "alert": "This is the message displayed in Notifications Center", 
                 "url": "http://www.inception-explained.com", 
                 "custom_properties": {"key1": "value1", "key2": "value2"}, 
                 "badge": "+1", 
                 "delivery_speed": "slow", 
                 "sound": "waves", 
                 "send_since": "2015-10-10 15:14:33 +0000", 
                 "tags": ["one", "two"], 
                 "group_name": "Commercial Offers"})
```
**Response**
```ruby
{
           "body" => {
                            "objects" => [
                             [0] {
                                                "id" => "f637304cf8c453e5",
                                             "sound" => "waves",
                                             "alert" => "This is the message displayed in Notifications Center",
                                             "title" => "Welcome to TwinPush",
                                             "badge" => "+1",
                                 "custom_properties" => {
                                     "key1" => "value1",
                                     "key2" => "value2"
                                 },
                                       "tp_rich_url" => "http://www.inception-explained.com",
                                    "delivery_speed" => "slow",
                                              "name" => nil,
                                        "group_name" => "Commercial Offers",
                                 "protected_content" => false,
                                        "send_since" => "2015-10-10 15:14:33 UTC",
                                              "tags" => [
                                     [0] "one",
                                     [1] "two",
                                     [2] "tp_rich"
                                 ],
                                              "type" => "Notification"
                             }
                         ],
                         "references" => []
                     },
        "headers" => { ... },
    "status_code" => 200,
       "response" => "success"
}
```
## Show notifications 
Obtains details from a previously created notification. _[See more](https://developers.twinpush.com/developers/api#get-show)_
```ruby
# for notification_id "f637304cf8c453e5"
twinpush.show('f637304cf8c453e5') 
```
## Report
Obtains delivery statistics for a given notification. _[See more](https://developers.twinpush.com/developers/api#get-report)_
```ruby
# for notification_id "f637304cf8c453e5"
twinpush.report('f637304cf8c453e5') 
```
## Deliveries
Obtains paginated list of all the deliveries for a given notification. This is useful to obtain exactly who has been the recipient of the notification and also who has opened it. _[See more](https://developers.twinpush.com/developers/api#get-deliveries)_
```ruby
# for notification_id "f637304cf8c453e5"
twinpush.deliveries('f637304cf8c453e5') 
```
## Inbox
Makes a paginated search of the notifications sent to an user through the device alias. It allows filtering by notification tags. _[See more](https://developers.twinpush.com/developers/api#get-inbox)_.
```ruby
# for device_id "846751075481e7481ea236562e6da9ff"
twinpush.inbox('846751075481e7481ea236562e6da9ff') 
```
## Inbox Summary
Obtains a fast summary of the notification inbox associated to the current device alias. It offers the total notification count and the unopened notification count. _[See more](https://developers.twinpush.com/developers/api#get-inbox-summary)_.
```ruby
# for device_id "846751075481e7481ea236562e6da9ff"
twinpush.inbox_summary('846751075481e7481ea236562e6da9ff') 
```
## Delete Inbox
Removes the selected notification from the inbox of the user (or alias) associated to the device. _[See more](https://developers.twinpush.com/developers/api#delete-inbox-notification)_.
```ruby
# for device_id "846751075481e7481ea236562e6da9ff" and notification_id f637304cf8c453e5
twinpush.delete_inbox('846751075481e7481ea236562e6da9ff', 'f637304cf8c453e5') 
```
## Search device notifications
Makes a paginated search of the notifications received by a device. It allows filtering by notification tags. _[See more](https://developers.twinpush.com/developers/api#post-set-custom-property)_
```ruby
# for device_id "846751075481e7481ea236562e6da9ff" 
twinpush.search_device_notifications('846751075481e7481ea236562e6da9ff', {tags: 'tp_rich'})
```

## Set custom property
Assign the value for the given custom property at the selected device. Custom properties are useful to create segmented targets and to obtain statistics based on custom information. _[See more](https://developers.twinpush.com/developers/api#post-set-custom-property)_
```ruby
# for device_id "846751075481e7481ea236562e6da9ff" 
twinpush.set_custom_property('846751075481e7481ea236562e6da9ff' ,{"name": "age", "type": "integer","value": 43})
```


