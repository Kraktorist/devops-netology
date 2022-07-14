#!/usr/bin/env python

import requests
import sentry_sdk

sentry_sdk.init(
    dsn="http://ab6bb312f6924724ac9dbe03fdc82304@localhost:9000/2",

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    traces_sample_rate=1.0,
    environment="production",
)

try:
    r = requests.get('http://nonexisting-domain.smdb')
except Exception as e:
    # Alternatively the argument can be omitted
    sentry_sdk.capture_exception(e)