# mailchimp-service fn

This functions for (fnproject.io) receives a JWT token and delete segments duplicateds in mailchimp

## input format
```
JWT_TOKEN_WITH_JSON_STRUCT
```

## output format
```
{
  status: "200",
  response: "sync_completed"
}
```

## how use

```
git clone https://github.com/nossas/mailchimp-service.git
cd mailchimp-service

fn apps config s YOUR_APP API_KEY mailchimp_api_key
fn apps config s YOUR_APP LIST_ID mailchimp_list_id

fn deploy --app YOUR_APP --local
```

calling the function via fn cli
```
echo JWT_TOKEN_WITH_JSON_STRUCT | fn call YOU_APP /mailchimp-service
```

