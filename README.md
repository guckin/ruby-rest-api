# Boat N Slip 
# A REST API

[![Build Status](https://travis-ci.com/LittleStevieBrule/boat-n-slip.svg?token=nZsgngm2TJU24WjBQ1Jf&branch=master)](https://travis-ci.com/LittleStevieBrule/boat-n-slip)


## API
```get /boats/{boat_id}```  
  Returns data for a single boat
  
  
  
```get /slips/{slip_id}```  
  Return data for a single boat
  
  
  
```get /boats```   
  Returns data for all boats



```get /slips```   
  Returns data for all slips
  
  
  
```get /slips/{boat_id}/boat```  
  Returns data for a boat that is docked in a slip given by `boat_id`



```post /boats ```   
  Creates a boat  
  Data required for creating a boat:
  ```json
{
  "name": "String",
  "type": "String",
  "length": "String"
}
```



  
```post /slips```  
  Creates a new slip

```delete /boats/{boat_id}```   
  Deletes a boat given by `slip_id`
  
```delete /slips/{slip_id}```   
  Deletes a slip given by `slip_id` 
  
```patch /boats/{boat_id}```  
  Updates a boat given by `boat_id` 
    
  Valid fields:
```json
{
  "name": "String",
  "type": "String",
  "length": "String",
  "at_sea": "Boolean"
}
```

```patch /slips/#{slip_id}```   
  Updates a slip given by `slip_id`
  
  Valid fields:  

```json
{
  "current_boat": "{boat_id}" 
}
```




```put /boats/{boat_id}/to_sea```   
  Sets a boat to be at sea. The boat is given by `boat_id`



```put /boats/{boat_id}/arrive```   
  Arrives a boat and Docks it into a the first available slip. The boat is given by `boat_id`



```put /boats/{boat_id}```   
  Replaces a boat. Note that replacing a boat that is docked sets it to be at sea
  
  Required fields:
```json
{
  "name": "String",
  "type": "String",
  "length": "String"
}
```


```put /slips/{slip_id}```

Replaces a Slip. Note that replacing a slip that has a boat docked causes that boat to be at sea  

## Getting started

```bundle install```

On Ubuntu:

```sudo service mongod start```

## Running Test

```bundle exec rake```

## Server
```ruby
require 'boat_n_slip'

BoatNSlip.server.run!
```
