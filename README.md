# Webhook Notifications

This Discourse plugin hijacks the email notifications and posts the raw
data used to build them to a webhook instead.

## Params you probably care about

   - `user_email`
   - `topic_title`
   - `discourse_url` (Note that this does not include the domain)
   - `template`

## Installation

### Using docker?

[Do this](https://meta.discourse.org/t/install-a-plugin/19157). Export `DISCOURSE_WEBHOOK`.


### Using a VPS?

```
export DISCOURSE_WEBHOOK="http://your_domain.com/api_endpoint"
rake plugin:install["https://github.com/jamesgecko/discourse-webhook-plugin.git"]
```

### Using Heroku?

- [Vendor the plugin](https://devcenter.heroku.com/articles/git-submodules#vendoring)
- Export `DISCOURSE_WEBHOOK`
