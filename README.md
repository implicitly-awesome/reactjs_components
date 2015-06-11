# Some React.js components

## Modal window
Just a modal window component. Depends on [underscore.js](http://underscorejs.org/)

### Usage
Here is the trigger method and it's params:
```javascript
reactModal = function (id, headerTitle, bodyContent, additionalClasses)
```

```html
<a class="klass" onclick="reactModal('new-modal', 'New Modal', $('#new-modal-body').html(), {content: 'content_class', header: 'header_class', body: 'body_class'});">Show modal</a>
```
It creates a modal container div, appends it to body and triggers the 'show' state param.
