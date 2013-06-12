# 500px Set Tag

Generates an image gallery from a 500px set. This is based on the works of [macjasp](http://carmo.org.uk/) & [tsmango](http://thomasmango.com/), all credits go to those two guys.

Usage:

   {% fpx_set 500px_username %}

Example:

   {% fpx_set henninghoyer %}

Default Configuration (override in _config.yml):

```fpx_set:
fpx_set:
gallery_tag:   'p'
gallery_class: 'fpxgallery'
a_target:      '_blank'
image_rel:     ''
feature:       'user'
consumer_key:  ''
```

You must provide a Consumer Key in order to query 500px so this _must_ be configured in _config.yml.

The feature parameter will give you some control over which images are returned by 500px, see their [API Documentation](https://github.com/500px/api-documentation/blob/master/endpoints/photo/GET_photos.md) for more details.
